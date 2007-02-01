Return-Path: <linux-kernel-owner+w=401wt.eu-S1422863AbXBANWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422863AbXBANWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 08:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422865AbXBANWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 08:22:54 -0500
Received: from wx-out-0506.google.com ([66.249.82.230]:40434 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422863AbXBANWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 08:22:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MjAgrTY8Lhg07VKMZDpXhOeckgWQAeXJLUr7ltsh7oV+D/85ZrMQh79nsPLELLtWdJa169n+OSXbz8bK0y5ZXAQikHUk/KVuGoql68IJepVB499yDNoRlmpi6E6Ra8ocLYMUAt5QdIRbCOLYxmcQRs3GvL9DWr0en370J7uPsSI=
Message-ID: <9a8748490702010522y7b9cd16y85602ed444263213@mail.gmail.com>
Date: Thu, 1 Feb 2007 14:22:51 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Subject: Re: Rewriting floppy.c was Re: Free Linux Driver Development!
Cc: "Andi Kleen" <ak@suse.de>, "Greg KH" <greg@kroah.com>,
       "Adrian Bunk" <bunk@stusta.de>, "Roland Dreier" <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <58cb370e0702010512j51cc2d06w6ffa6df12bbc99f6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>
	 <20070130191020.GF20642@kroah.com> <20070131011340.GP3754@stusta.de>
	 <20070131012428.GA31759@kroah.com> <p7364anpkz5.fsf_-_@bingen.suse.de>
	 <58cb370e0702010512j51cc2d06w6ffa6df12bbc99f6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/07, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> On 31 Jan 2007 11:08:14 +0100, Andi Kleen <ak@suse.de> wrote:
> > Greg KH <greg@kroah.com> writes:
> > >
> > > What?  Throw a fresh-faced newbie instantly into the tar-pit of despair
> > > that floppy.c is?  Do you want everyone just to run screaming from
> > > kernel development never to be seen again?
>
> floppy.c is not really that ugly or complicated...
>
> It just needs some care:
>
> * cleanup of the over-usage of macros (DP macro etc)
> * DocBook documentation would be nice
> * make debugging printks optional by using macros in a smart way
>   (see libata code for examples)
> * tracking and fixing current regressions
>
> Once the above is done there would be more room
> for the future cleanups and improvements like:
>
> * using bios directly in copy_buffer()
>   (or avoiding copy completely if possible - need somebody to look at code)
> * map user pages instead of memcpy-ing them in fd_copy{in,out}()
> * unifying/merging arch specific code into floppy.c (not sure of this one)
> * smarter way to handle IRQs
>
> floppy.c rewrite offers an unique chance to learn by practice
> from doing simple tasks (macros cleanup) to more advances ones
> (involving block layer mechanisms) up to really difficult ones
> (IRQ/"actual work" handling methods).
>
> I could help with reviewing patches in case anybody is interested
> and have patience to deal with few days delays for reply.  However
> please don't add me to MAINTAINERS as floppy diver maintainer.
>
> :)
>
> > Doing a from-scratch rewrite of floppy.c only supporting new
> > hardware and no obscure formats ("newfloppy.c") would be an excellent
> > newbie project imho.  This means for someone who is still pretty
> > new, but wants to get their fingers wet with more complicated changes.
> >
> > Then over time (old-)floppy.c could be phased out.
>
> * this is unlikely that we need to add support for new hardware
> * by doing the rewrite from scratch we will lose changes history
>   and possibility to easily track regressions
> * for a long time we would have to deal with both drivers
>
> This is just not worth it IMHO.
>

Good points. I'll try cleaning up the existing driver instead of doing
a complete rewrite.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
