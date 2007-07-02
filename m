Return-Path: <linux-kernel-owner+w=401wt.eu-S1756284AbXGBVHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbXGBVHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 17:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754720AbXGBVHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 17:07:09 -0400
Received: from gw.goop.org ([64.81.55.164]:58362 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755073AbXGBVHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 17:07:08 -0400
Message-ID: <468968F8.9060700@goop.org>
Date: Mon, 02 Jul 2007 14:07:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: lkml <linux-kernel@vger.kernel.org>, stable@kernel.org,
       Chuck Ebbert <76306.1226@compuserve.com>
Subject: Re: [PATCH] i386 - Fix regression, endless loop in ptrace singlestep
 over an int80
References: <468965D8.7020405@windriver.com>
In-Reply-To: <468965D8.7020405@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wessel wrote:
>
> Attached is a patch with a complete test case to fix the regression 
> introduced by the commit: 635cf99a80f4ebee59d70eb64bb85ce829e4591f.
>
> This patch is against kernel 2.6.21 but the fix is applicable to 
> 2.6.21 and up.  Prior to the commit that introduced the regression the 
> ltp ptrace tests would complete correctly.  I augmented the test case 
> from the original patch header to include the problem case that shows 
> up in the lpt tests.
>
> The brief summary is that the the TIF_SINGLESTEP state needs to be 
> altered on the exit path and not the entry path to a syscall, else it 
> can loop forever on the same instruction right after the syscall is 
> executed in certain cases. 

Looks reasonable to me, but what under what circumstances can 
TIF_SINGLESTEP get lost?

    J

