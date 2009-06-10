Return-Path: <linux-kernel-owner+w=401wt.eu-S1759579AbZFJADT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759579AbZFJADT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 20:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbZFJADH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 20:03:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48189 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbZFJADG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 20:03:06 -0400
Message-ID: <4A2EF833.6080300@zytor.com>
Date: Tue, 09 Jun 2009 17:02:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Andrew Morton <akpm@linux-foundation.org>, renton@renton.name,
       linux-kernel@vger.kernel.org
Subject: Re: devpts mounts too slowly
References: <20090603142801.GC21646@beaver.vrungel.ru> <4A26EB18.6060907@zytor.com> 	<20090609161945.811cc01f.akpm@linux-foundation.org> <2c0942db0906091630l1cc79647h8689e9e929ed1bba@mail.gmail.com>
In-Reply-To: <2c0942db0906091630l1cc79647h8689e9e929ed1bba@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:
>>
>> akpm2:/home/akpm/xx# time mount -n -i -t devpts none /tmp/pts
>> mount -n -i -t devpts none /tmp/pts  0.00s user 0.00s system 0% cpu 0.002 total
> 
> I read the Original Post as that test being performed with 5k /dev/pts
> already mounted.

A quick script seems to confirm that the time starts creeping up as the
number of mount points increase; on my Core i7 system the 10000th mount
takes around 50 ms whereas the early instances are submillisecond, and
the increase *seems* to be O(n log n) or thereabouts -- slightly
superlinear but not a good fit for a power law.

The same thing happens with ramfs, so the problem is either in libfs or
in the VFS; I suspect the latter as I don't really think we have had a
huge reason to optimize a very large number of mounts in the past.

	-hpa
