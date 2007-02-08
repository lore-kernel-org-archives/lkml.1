Return-Path: <linux-kernel-owner+w=401wt.eu-S1423441AbXBHVhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423441AbXBHVhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 16:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423442AbXBHVhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 16:37:36 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:4213 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423441AbXBHVhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 16:37:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aOrKNYxdq2a1Bc+g1BLZAmbyRQX3EtGgDU6XaliZkV5+HX6gpzmLIaEX+8DQciyHT0kBoEBvxjJrLtL0/9s9gaCEK66XUjM9b1gdaHopRVD2bDDlCXFWfCRq4bpDOI/laazsBcTM9YjB8HGWwvVpW1DOH5jkhwRYQxRylFy1AhU=
Message-ID: <d120d5000702081337j3eecbc41r4e9e44014b7cedfe@mail.gmail.com>
Date: Thu, 8 Feb 2007 16:37:31 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Zachary Amsden" <zach@vmware.com>
Subject: Re: [PATCH 9/11] Panic delay fix
Cc: "Rusty Russell" <rusty@rustcorp.com.au>, "Pavel Machek" <pavel@ucw.cz>,
       "Andi Kleen" <ak@muc.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Chris Wright" <chrisw@sous-sol.org>
In-Reply-To: <45CB9588.50300@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702060353.l163rUmj000771@zach-dev.vmware.com>
	 <20070206122729.GC47229@muc.de> <45C8FA2D.6010706@vmware.com>
	 <20070207123552.GD4481@ucw.cz>
	 <1170880572.11736.4.camel@localhost.localdomain>
	 <d120d5000702080643k453e73e3h6d481f9d65a4e856@mail.gmail.com>
	 <45CB9588.50300@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/8/07, Zachary Amsden <zach@vmware.com> wrote:
> Dmitry Torokhov wrote:
> >
> > However I am not really fond of idea of adding constructs like this
> > all over the code:
> >
> > #define USE_REAL_TIME_DELAY_I_REALLY_MEAN_IT_THIS_TIME_I_SWEAR
> >
> > as the time passes... Drivers should be blissfully ignorant of being
> > run on virtual hardware.
>
> I agree in general, but there are two uses for this ugly construct.  One
> is for drivers and isolated sections of code which actually interact
> with the real world.  They need real time delays.  The only two examples
> so far are SMP coprocessor bootstrapping and blinking LEDs with a
> recognizable frequency.  I don't expect many more to show up.
>

I am pretty sure that using that construct inside of i8042 is wrong -
the host OS should handle hardware access/delay issues. Have you
verified that fixing kerne/panic.c to call i8042_panic_blink once per
1 ms (as it happens on native running kernel) does not produce the
desired blinking?

-- 
Dmitry
