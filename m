Return-Path: <linux-kernel-owner+w=401wt.eu-S934135AbYGCHKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934135AbYGCHKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbYGCG6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:58:08 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45210 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbYGCEql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 00:46:41 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5330"; a="4251858"
Message-ID: <486C59BE.3020400@qualcomm.com>
Date: Wed, 02 Jul 2008 21:46:54 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: a.p.zijlstra@chello.nl, pj@sgi.com, vegard.nossum@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] CGroups: Add a per-subsystem hierarchy lock
References: <20080627075912.92AE43D6907@localhost>	 <6599ad830806271702y2c1df2edh3a75dda75336ddad@mail.gmail.com>	 <486AFC33.7010901@qualcomm.com> <6599ad830807021531r16013460re28f813be8293d6c@mail.gmail.com>
In-Reply-To: <6599ad830807021531r16013460re28f813be8293d6c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Paul Menage wrote:
> On Tue, Jul 1, 2008 at 8:55 PM, Max Krasnyansky <maxk@qualcomm.com> wrote:
>> I was about to say "yeah, looks good" and then tried a couple of
>> different hot-plug scenarious.
>> We still have circular locking even with your patch
>>
> 
> What sequence of actions do you do? I've not been able to reproduce a
> lockdep failure.

mkdir /dev/cpuset
mount -t cgroup -o cpuset cpuset /dev/cpuset
mkdir /dev/cpuset/0
mkdir /dev/cpuset/1
echo 0-2 > /dev/cpuset/0/cpuset.cpus
echo 3   > /dev/cpuset/1/cpuset.cpus
echo 0 > /dev/cpuset/cpuset.sched_load_balance
echo 0 > /sys/devices/system/cpu/cpu3/online

I just tried it again and got exact same lockdep output that I sent before.

Max

