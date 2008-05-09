Return-Path: <linux-kernel-owner+w=401wt.eu-S1765924AbYEITXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765924AbYEITXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 15:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756274AbYEITX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 15:23:29 -0400
Received: from smtprelay07.ispgateway.de ([80.67.29.7]:35036 "EHLO
	smtprelay07.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbYEITX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 15:23:28 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Brian McGrew <brian@visionpro.com>
Subject: Re: Restricting Processor Usage
Date: Fri, 9 May 2008 21:28:56 +0200
User-Agent: KMail/1.9.9
References: <C449C986.1E7ED%brian@visionpro.com>
In-Reply-To: <C449C986.1E7ED%brian@visionpro.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805092128.56917.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian
On Friday 09 May 2008, you wrote:
> Now that I've got sched_(set|get)affinity working (thank you all for all of
> the great help), I need to figure out how to unload the processors in the
> machine.

excerpt from Documentation/kernel-parameters.txt:

        isolcpus=       [KNL,SMP] Isolate CPUs from the general scheduler.
                        Format:
                        <cpu number>,...,<cpu number>
                        or
                        <cpu number>-<cpu number>  (must be a positive range in ascending order)
                        or a mixture
                        <cpu number>,...,<cpu number>-<cpu number>
                        This option can be used to specify one or more CPUs
                        to isolate from the general SMP balancing and scheduling
                        algorithms. The only way to move a process onto or off
                        an "isolated" CPU is via the CPU affinity syscalls.
                        <cpu number> begins at 0 and the maximum value is
                        "number of CPUs in system - 1".

                        This option is the preferred way to isolate CPUs. The
                        alternative -- manually setting the CPU mask of all
                        tasks in the system -- can cause problems and
                        suboptimal load balancer performance.

And then use sched_set_affinity to fill your CPUs.

Happy imaging :-)


Best Regards

Ingo Oeser
