Return-Path: <linux-kernel-owner+w=401wt.eu-S1762000AbYCERwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762000AbYCERwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 12:52:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760949AbYCERvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 12:51:50 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:55979 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038AbYCERvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 12:51:49 -0500
X-IronPort-AV: E=Sophos;i="4.25,451,1199682000"; 
   d="scan'208";a="49634830"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: PATCH [1/1]: Don't return symbol lables in init sections after they have been freed
Date: Wed, 5 Mar 2008 12:53:27 -0500
User-Agent: KMail/1.9.5
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>
References: <200803041847.15884.rgetz@blackfin.uclinux.org> <200803051243.26732.rusty@rustcorp.com.au>
In-Reply-To: <200803051243.26732.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803051253.28761.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 05 Mar 2008 17:51:47.0626 (UTC) FILETIME=[953BC0A0:01C87EE9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 4 Mar 2008 20:43, Rusty Russell pondered:
> On Wednesday 05 March 2008 10:47:15 Robin Getz wrote:
> > From: Robin Getz <rgetz@blackfin.uclinux.org>
> >
> > Today, when module names are looked up, we do not qualify them (check to
> > see if the init section is still active or not). This can lead to problems
> > when kernel modules get loaded into the same address that the kernel init
> > section (or other module's init section was at). We sometimes return the
> > old / no lomnger there
> >
> > This leads to bogus OOPS messages, and developers wasting their time
> > looking for problems (in the kernel init section) where there are none
> > (since it was a module).
> 
> Hi Robin,
> 
>     This is a great explanation, with only one problem: it isn't true.  

I can replicate this on 2.6.24.3 (at least on noMMU) in the kernel init 
section. 

> mod->init_size is set to zero after init.

So, I have seen the problem on the init section, and suspected it could happen 
on module init, but it looks like I missed that portion of the code - sorry.

>     As to the actual patch, your kallsyms.c patch matches 
> a2da4052f1df6bc77749f84496fe731ab8b458f7's change to extable.c: please 
> resubmit with just that one. 

Will do.

> For bonus points, look at combining the 
> extable and kallsyms logic so we don't diverge in future...

Let me see what I can do. 
