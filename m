Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbXGBWD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbXGBWD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 18:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755988AbXGBWDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 18:03:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887AbXGBWDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 18:03:50 -0400
Message-ID: <46897642.9030407@redhat.com>
Date: Mon, 02 Jul 2007 18:03:46 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: lkml <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [PATCH] i386 - Fix regression, endless loop in ptrace singlestep
 over an int80
References: <468965D8.7020405@windriver.com>
In-Reply-To: <468965D8.7020405@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2007 04:53 PM, Jason Wessel wrote:
> 
> Attached is a patch with a complete test case to fix the regression
> introduced by the commit: 635cf99a80f4ebee59d70eb64bb85ce829e4591f.
> 
> This patch is against kernel 2.6.21 but the fix is applicable to 2.6.21
> and up.  Prior to the commit that introduced the regression the ltp
> ptrace tests would complete correctly.  I augmented the test case from
> the original patch header to include the problem case that shows up in
> the lpt tests.
> 
> The brief summary is that the the TIF_SINGLESTEP state needs to be
> altered on the exit path and not the entry path to a syscall, else it
> can loop forever on the same instruction right after the syscall is
> executed in certain cases.

Where does it loop?

