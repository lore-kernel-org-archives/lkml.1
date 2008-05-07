Return-Path: <linux-kernel-owner+w=401wt.eu-S1756621AbYEGUwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbYEGUwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 16:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755111AbYEGUwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 16:52:17 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:53313 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758813AbYEGUwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 16:52:13 -0400
Message-ID: <4822166F.50002@krogh.cc>
Date: Wed, 07 May 2008 22:51:59 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: "Randy.Dunlap" <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Many open/close on same files yeilds "No such file or directory".
References: <4819E316.7000607@krogh.cc> <481ACEC4.2040205@krogh.cc>	 <481B3115.30705@krogh.cc>	 <2c0942db0805020847q2fdc0480m3eb892bf2bd0b3a@mail.gmail.com>	 <481B70F9.6000201@krogh.cc> <481F4728.9050100@krogh.cc>	 <Pine.LNX.4.64.0805051050350.27703@shark.he.net>	 <481F49C0.4080001@krogh.cc>	 <2c0942db0805051121r47cc97d2jb71cc8ab9eaa7981@mail.gmail.com>	 <481F51F0.4000408@krogh.cc> <2c0942db0805051154q63a18bcfhce8a30d4a663ea3f@mail.gmail.com>
In-Reply-To: <2c0942db0805051154q63a18bcfhce8a30d4a663ea3f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:
> On Mon, May 5, 2008 at 11:29 AM, Jesper Krogh <jesper@krogh.cc> wrote:
>>> I'd been meaning to ask what the topology was. External, eh? Are you
>>> sure the enclosure, cabling, and card/connectors are all good? Have
>>> you tried swapping out cables?
>>>
>>  It is new SCSI-controller, new cable and new terminator put onto it. But
>>  (just enlighten me), if I had problems at this level I'd expect the
>>  serverlog to be full of SCSI/FS-related errors and not just a single
>>  syscall, that doesn't even touch the array due to caching, to be
>>  failing.
> 
> Borderline hardware does not always create logged errors.

Ok. I think this _really_ point to a kernel problem.
(or just some broken hardware from Sun in multiple copies)

> If I understood you correctly earlier, identical hardware on another
> system does not show the error. That, quite honestly, rules out the
> software.

Now I've moved the data to fresh ext3 filesystems on a storage-array
based on iscsi. Mounted the filesystems to another, similar server and
I can still reproduce the problem.

Both servers are 16 cores. The problem wasn't there on a different 
server with only 2 cores. (or I didn't run into it).

The 3 setups above has both been tested with a 2.6.22-14-server and 
2.6.24-17-server (towards the iscsi volume).

Doing more testing show that I have 3 machines (all X4600, 16 cores/32GB 
ram that I can reproduce it on against different filesystem)

The more processes running on the system (accessing the FS volume), the
easier it seems to get into the problem.

> What's left, however unlikely, has to be the issue. And what's left is
> your scsi controller, the cable, and the external disk array.

Now I've removed all of them.. and still got the problem.

-- 
Jesper
