Return-Path: <linux-kernel-owner+w=401wt.eu-S1423046AbXBHOn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423046AbXBHOn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 09:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423076AbXBHOn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 09:43:59 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:7618 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423046AbXBHOn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 09:43:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Oi6QLHHbl/wXsbD87qjqYKk31NwPp+ajixXAD12+6ecWZXa0un8LK2B6y06BJjEFml7dOFGlse8GmhC7mb6RkaY+B+LzpzcFoEN+RHMHJJeblxdK/z43ETxes8Wcz/HIiPDnVdoZtSEAYe3oez9Ma0gEqzo8INzH0fLMgzrAlPs=
Message-ID: <d120d5000702080643k453e73e3h6d481f9d65a4e856@mail.gmail.com>
Date: Thu, 8 Feb 2007 09:43:56 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [PATCH 9/11] Panic delay fix
Cc: "Pavel Machek" <pavel@ucw.cz>, "Zachary Amsden" <zach@vmware.com>,
       "Andi Kleen" <ak@muc.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Chris Wright" <chrisw@sous-sol.org>
In-Reply-To: <1170880572.11736.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702060353.l163rUmj000771@zach-dev.vmware.com>
	 <20070206122729.GC47229@muc.de> <45C8FA2D.6010706@vmware.com>
	 <20070207123552.GD4481@ucw.cz>
	 <1170880572.11736.4.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/7/07, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Wed, 2007-02-07 at 12:35 +0000, Pavel Machek wrote:
> > Ugh, it sounds like paravirt is more b0rken then I thought. It should
> > always to the proper delay, then replace those udelays that are not
> > needed on virtualized hardware with something else.
> >
> > Just magically defining udelay into nop is broken.
>
> We'd have to audit and figure out what udelays are for hardware and
> which are not, but the evidence is that the vast majority of them are
> for hardware and not needed for virtualization.
>
> Changing udelay to "hardware_udelay" or something all over the kernel
> would have delayed the paravirt_ops merge by an infinite amount 8)
>

However I am not really fond of idea of adding constructs like this
all over the code:

#define USE_REAL_TIME_DELAY_I_REALLY_MEAN_IT_THIS_TIME_I_SWEAR

as the time passes... Drivers should be blissfully ignorant of being
run on virtual hardware.

-- 
Dmitry
