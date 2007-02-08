Return-Path: <linux-kernel-owner+w=401wt.eu-S1423054AbXBHOlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423054AbXBHOlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 09:41:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423046AbXBHOlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 09:41:11 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:4877 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423054AbXBHOlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 09:41:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sp0wzgviiHkA7pGqlIIPe1eDDV/CcV9jMmXSDjx5cQwNntYs1eyjP66tX+vViSt9DKA4xgg5slhAyPsgb7n70sGqqiu3KevCZqzF62kvKHPfJVWRhWaJ6peBvywrN0HSC3MoUJOqATBhq+ZfOqDIBZeWi1MPGNP49oVCYL5GdX4=
Message-ID: <d120d5000702080641p515b0226v27f208d0e685b898@mail.gmail.com>
Date: Thu, 8 Feb 2007 09:41:03 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Andi Kleen" <ak@muc.de>
Subject: Re: [PATCH 9/11] Panic delay fix
Cc: "Zachary Amsden" <zach@vmware.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Chris Wright" <chrisw@sous-sol.org>
In-Reply-To: <20070208133321.GA36397@muc.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702060353.l163rUmj000771@zach-dev.vmware.com>
	 <20070206122729.GC47229@muc.de> <45C8FA2D.6010706@vmware.com>
	 <d120d5000702070658l1c018565n34a6d8814a20184d@mail.gmail.com>
	 <45CA535D.1080700@vmware.com> <20070208082443.GA9928@muc.de>
	 <45CAE87E.8070502@vmware.com> <20070208133321.GA36397@muc.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 Feb 2007 14:33:21 +0100, Andi Kleen <ak@muc.de> wrote:
> On Thu, Feb 08, 2007 at 01:08:14AM -0800, Zachary Amsden wrote:
> > Andi Kleen wrote:
> > >On Wed, Feb 07, 2007 at 02:31:57PM -0800, Zachary Amsden wrote:
> > >
> > >>Dmitry Torokhov wrote:
> > >>
> > >>>I am confused - does i8042 talk to a virtual or real hardware here? In
> > >>>any case I think you need to fix kernel/panic.c to have proper
> > >>>(m)delay, not mess with i8042.
> > >>>
> > >>I think I need to fix both of them actually.  This is virtual hardware,
> > >>but when you grab focus on a VM, the virtual hardware gets reflected to
> > >>the actual physical keyboard.  Driving physical hardware that fast is bad.
> > >>
> > >
> > >???
> > >
> > >Surely the physical keyboard is always handled by the host kernel?
> > >I hope you're not saying it's trying to access the io ports directly?
> > >
> >
> > No, not that.  But the virtual keyboard I/O gets processed and converted
> > to physical keyboard I/O when a keyboard is attached to a VM.  The
>
> You mean the commands to change the keyboard LEDs?
>
> > result is that the virtual keyboard spinning out of control causes the
> > physical keyboard to receive the same commands, far too rapidly.
>
> Hmm i would expect the host kernel keyboard driver to throttle these.
> I'm pretty sure the Linux one does the necessary mdelays at least.

There is no throttling, we will switch leds as fast as keyboard
controller will allow us (not that I consider it a bad thing).

>
> > So the keyboard blinks out of control and acts as if possessed by demons.
>
> Still sounds weird.
>

The problem is that panic blink routine expects to be called with 1ms
frequency. If mdelay in kernel/panic.c is changed to noop then i8042
will try to blink as fast as it possibly can.

-- 
Dmitry
