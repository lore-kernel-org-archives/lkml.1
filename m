Return-Path: <linux-kernel-owner+w=401wt.eu-S1161347AbXBGO7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161347AbXBGO7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 09:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161350AbXBGO7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 09:59:12 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:52508 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161347AbXBGO7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 09:59:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gSwz1b1MWRhtJa+JqnjJLbSgonlbpSsDi4d7YDjv66XLspoTlEMZ/NgggP0WExLqewb+LSm+1vysheFiI+tOpxkkonXWEPEO1ueyCjudyeJrGgwyIo609JDhsLtqbRaAxQSpr3upAm4oLd5qpBmUEX3JO6oicMSrsYntzVC8Hps=
Message-ID: <d120d5000702070658l1c018565n34a6d8814a20184d@mail.gmail.com>
Date: Wed, 7 Feb 2007 09:58:57 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Zachary Amsden" <zach@vmware.com>
Subject: Re: [PATCH 9/11] Panic delay fix
Cc: "Andi Kleen" <ak@muc.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Chris Wright" <chrisw@sous-sol.org>
In-Reply-To: <45C8FA2D.6010706@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702060353.l163rUmj000771@zach-dev.vmware.com>
	 <20070206122729.GC47229@muc.de> <45C8FA2D.6010706@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/6/07, Zachary Amsden <zach@vmware.com> wrote:
> Andi Kleen wrote:
> > On Mon, Feb 05, 2007 at 07:53:30PM -0800, Zachary Amsden wrote:
> >
> >> Failure to use real-time delay here causes the keyboard to become demonically
> >> possessed in the event of a kernel crash, with wildly blinking lights and
> >> unpredictable behavior.  This has resulted in several injuries.
> >>
> >
> > There must be a reason why it wasn't default before. Has this
> > reason changed?
> >
>
> This only matters under paravirt; non-paravirt kernels and kernels
> running on native hardware will always behave properly.
>
> But paravirtualized kernels with fake devices have no need to udelay to
> accommodate slow hardware - the hardware is just virtual.  The
> USE_REAL_TIME_DELAY define allows udelay to be specifically reverted
> back to being a real delay.  There are only a couple cases where it
> matters - one is booting APs on SMP systems (there is a real delay
> before they come up), and one is any hardware that drives world
> interacting devices - such as keyboard LEDs in a panic loop.
>

I am confused - does i8042 talk to a virtual or real hardware here? In
any case I think you need to fix kernel/panic.c to have proper
(m)delay, not mess with i8042.

-- 
Dmitry
