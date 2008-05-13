Return-Path: <linux-kernel-owner+w=401wt.eu-S1760957AbYEMPdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760957AbYEMPdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 11:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757181AbYEMPdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 11:33:04 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:11621
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782AbYEMPdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 11:33:01 -0400
Message-ID: <4829B4AC.6090909@qumranet.com>
Date: Tue, 13 May 2008 18:33:00 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] cpu hotplug vs scheduler
References: <4829A6A0.5040208@qumranet.com>
In-Reply-To: <4829A6A0.5040208@qumranet.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> I'm testing host cpu hotplug with kvm.  Basically running 7 guests on 
> a 4 core machine, offlining and onlining host cpus at random.  
> Eventually I hit this:
>

[snip oops]

> This seems to be the assignment to cfs_rq after pick_next_entity().
>
> I'm running kvm.git, which is currently 2.6.26-rc2 plus a few kvm 
> patches.  It could be kvm's fault, but it doesn't appear so from the 
> traces.
>

I get the same oops running with the kvm modules unloaded.  None of 
kvm.git's changes are in core code, so this is definitely a mainline 
problem.

It took about 40 minutes to reproduce; 1200 cpus onlined and 1200 cpus 
offlined.

-- 
error compiling committee.c: too many arguments to function

