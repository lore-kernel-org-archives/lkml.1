Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbYEFLS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbYEFLS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 07:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYEFLSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 07:18:48 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:36211 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbYEFLSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 07:18:48 -0400
Date: Tue, 6 May 2008 05:18:31 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080506111831.GG19219@parisc-linux.org>
References: <1210052904.3453.30.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210052904.3453.30.camel@ymzhang>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 01:48:24PM +0800, Zhang, Yanmin wrote:
> Comparing with kernel 2.6.25, ???AIM7 (use tmpfs) has ???more than 40% with 2.6.26-rc1
> on my 8-core stoakley, 16-core tigerton, and Itanium Montecito. Bisect located
> below patch.
> 
> 64ac24e738823161693bf791f87adc802cf529ff is first bad commit
> commit 64ac24e738823161693bf791f87adc802cf529ff
> Author: Matthew Wilcox <matthew@wil.cx>
> Date:   Fri Mar 7 21:55:58 2008 -0500
> 
>     Generic semaphore implementation
> 
> 
> After I manually reverted the patch against 2.6.26-rc1 while fixing lots of
> conflictions/errors, aim7 regression became less than 2%.

40%?!  That's shocking.  Can you tell which semaphore was heavily
contended?  I have a horrible feeling that it's the BKL.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
