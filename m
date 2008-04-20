Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbYDTXwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbYDTXwl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 19:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbYDTXwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 19:52:33 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:12435
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbYDTXwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 19:52:32 -0400
Message-ID: <480BD665.20804@qumranet.com>
Date: Mon, 21 Apr 2008 02:48:53 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Bernd Eckenfels <ecki@lina.inka.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: x86: 4kstacks default
References: <E1Jnhr0-00076D-00@calista.eckenfels.net>
In-Reply-To: <E1Jnhr0-00076D-00@calista.eckenfels.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0rc1 (firebolt.argo.co.il [0.0.0.0]); Mon, 21 Apr 2008 02:48:53 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Eckenfels wrote:
> A question along this line. Why is the Userspace Thread bound to a
> Kernel-Space Stack at all? I could imagine a solution like Stack Pools
> assigned only of a Thread enters kernel space, or something like this?
>
>   

The vast majority of threads are sleeping (with a stack footprint in the 
kernel).  If you have an N-way system, at most N threads can be in 
userspace at any given moment.

You could multiplex several userspace threads on one kernel thread (the 
M:N model), but it gets fairly complex.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

