Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYERPHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYERPHp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 11:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbYERPHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 11:07:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35589 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbYERPHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 11:07:35 -0400
Date: Sun, 18 May 2008 11:07:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: J?rgen Mell <j.mell@t-online.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CONFIG_PREEMPT causes corruption of application's FPU stack
Message-ID: <20080518150733.GC8100@goodmis.org>
References: <200805171831.08490.j.mell@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805171831.08490.j.mell@t-online.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2008 at 06:31:08PM +0200, J?rgen Mell wrote:
> 
> I tracked this down to a single kernel configuration option. If 
> CONFIG_PREEMPT is set to 'y' the application will start crashing. If 
> CONFIG_PREEMPT is replaced by CONFIG_PREEMPT_VOLUNTARY, the application 
> will run without errors.
> 
> The problem is reproducible in so far as the error always occurs when 
> CONFIG_PREEMPT is set, but the time to the first occurrence varies greatly 
> from some minutes up to more than 10 CPU hours.
> 
> I found this error first on an openSUSE kernel 2.6.22.17-0.1-rt. I verified 
> the problem on the following kernel versions:
> 
> openSUSE 2.6.22.17-0.1-default
> openSUSE 2.6.23.17-ccj64-rt
> kernel.org 2.6.26-rc1
> kernel.org 2.6.26-rc2-git5

So you see this error in both the SuSE RT kernel, *and* mainline
kernel.org?

If you see it in the kernel.org kernel, can you please do a git-bisect
to see which commit caused the problem?

Thanks,

-- Steve

> 
> My CPU is an Intel Core2Duo 6420, running two of the Einstein applications 
> in 32-bit mode. From a discussion on the Einstein message boards I know 
> that other user of the application are also affected.
> 
