Return-Path: <linux-kernel-owner+w=401wt.eu-S1751829AbXLDTmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbXLDTmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 14:42:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbXLDTlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 14:41:44 -0500
Received: from nz-out-0506.google.com ([64.233.162.226]:38362 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbXLDTlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 14:41:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C7H9G0JBkeZDo6Ef1D89MYnBMzxtm6ifr+/69UmIKnabJKdYdkEDJ6FEOzsA6KUv7G4vn/169qKKyxNTxpiXPWx+WDzNhBLnbjmM3cua9g6CD1jTRvvwjjsHwOsB76IyzyenZFKXiXiGnkca1EIXNy9xEa/p4b9X9givrHHye7c=
Message-ID: <5d6222a80712041141p5fbc0c0ei68696f054cc8a303@mail.gmail.com>
Date: Tue, 4 Dec 2007 17:41:41 -0200
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Avi Kivity" <avi@qumranet.com>
Subject: Re: [PATCH 4/8] unify paravirt parts of system.h
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com
In-Reply-To: <4755A809.4050305@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11967843881946-git-send-email-gcosta@redhat.com>
	 <11967843943958-git-send-email-gcosta@redhat.com>
	 <11967843983411-git-send-email-gcosta@redhat.com>
	 <11967844032081-git-send-email-gcosta@redhat.com>
	 <11967844071346-git-send-email-gcosta@redhat.com>
	 <4755A809.4050305@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 4, 2007 5:18 PM, Avi Kivity <avi@qumranet.com> wrote:
> Glauber de Oliveira Costa wrote:
> > This patch moves the i386 control registers manipulation functions,
> > wbinvd, and clts functions to system.h. They are essentially the same
> > as in x86_64, except for the cr8 register, which we add.
> >
> > +
> > +static inline unsigned long native_read_cr8(void)
> > +{
> > +     unsigned long cr8;
> > +     asm volatile("mov %%cr8,%0" : "=r" (cr8), "=m" (__force_order));
> > +     return cr8;
> > +}
> > +
> >
>
> There is no cr8 register on i386.  This had better be protected by an
> #ifdef.

Sure. I mentioned it in the changelog. I, however, am not sure If I
agree it should be enclosed
in ifdefs. Me and Jeremy discussed it a while ago, and we seem to
agree that for those functions
that are exclusive of one architecture, there were no need for ifdefs.
Any usage by the other arch
is a bug.

But I admit that I'm not particularly biased here, and I can change
it, if there's agreement that
an ifdef here is the way to go.

> (you're likely not getting an error since it's a static inline, so the
> asm is never emitted)
>
Which also means it does not affect the binary in anyway. No bigger
code, no nothing.
My current approach is to save the ifdefs for pieces that in fact can
save us some resources
in the final image. But again... I can change it.



-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
