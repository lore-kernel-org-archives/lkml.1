Return-Path: <linux-kernel-owner+w=401wt.eu-S1758561AbZANAxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561AbZANAxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 19:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754008AbZANAxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 19:53:14 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:48917 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbZANAxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 19:53:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=h9/WwDugw+tiU8Kroj3MIAZKzGlNes15XBCIMTUguyRzcZdcZQny0yNAm0nfwSis9s
         U0crJF8o5P+XAJzzPryVZWK2pLDxf02sy5MHFKTfQiVIoz2h0sh2QnB5HuhSqacMhLO/
         LROAk5m/pqauMa6X+P9oDLuZiYnyaIrerPk9s=
Message-ID: <cfd18e0f0901131653y76a827b5i906fadce63ada56b@mail.gmail.com>
Date: Wed, 14 Jan 2009 13:53:10 +1300
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH] sys_waitid: return -EFAULT for NULL
Cc: "Roland McGrath" <roland@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901131629220.6528@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0901131436ud2cf61bkf0e6b00f4b765bb5@mail.gmail.com>
	 <cfd18e0f0901131438n232ba114n27ea2d7964d071de@mail.gmail.com>
	 <20090113224759.7DFB7FC3DD@magilla.sf.frob.com>
	 <20090113224941.36F19FC3DD@magilla.sf.frob.com>
	 <alpine.LFD.2.00.0901131629220.6528@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 1:33 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Tue, 13 Jan 2009, Roland McGrath wrote:
>>
>> It's always been invalid to call waitid() with a NULL pointer.  It was an
>> oversight that it was allowed (and acts like a wait4() call instead).
>
> I'm not going to take this.
>
> If it was some new system call, of if there was some downside to out
> behavior, I might be interested. As it is, our behaviour has zero
> downside, and changing existing interfaces simply isn't worth it.

It has zero downside for *us*.  But it is yet another example of Linux
littering the Unix landscape with unnecessary inconsistencies that
application writers must deal with.  That's a downside for the app
writers.  (But, given how long the existing behavior has been in the
wild, my argument here is somewhat academic...)

> The alleged "downsides" are bogus:
>
>  - POSIX is not that strict.

Well, POSIX.1-2001 is fairly clear:

      The  application shall ensure that the infop argument points to
      a siginfo_t structure.

(Admittedly, this is a requirement imposed on the application, rather
than the implementation, but the standard goes on to say that the
implemenation shall fill in the structure pointed to by infop.)

Cheers,

Michael

>   EFAULT is one of the odd error cases anyway,
>   and even explicit requirements are irrelevant: if somebody wants to get
>   strict conformance paperwork done, you just need to tell where you
>   differ, and you're basically done. But perhaps more important, nobody
>   cares.
>
>  - The "portability" argument is totally bogus, since it's not like you
>   compile programs without even testing to another UNIX _anyway_.
>
> So I'm simply not going to potentially break binaries over something that
> is so _totally_ irrelevant. Document it in the man-page instead.

Well, that's doable of course.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
