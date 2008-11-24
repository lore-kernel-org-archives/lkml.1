Return-Path: <linux-kernel-owner+w=401wt.eu-S1752386AbYKXHTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbYKXHTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 02:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYKXHTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 02:19:44 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:49962 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbYKXHTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 02:19:43 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <492A5557.2010404@s5r6.in-berlin.de>
Date: Mon, 24 Nov 2008 08:18:47 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.17) Gecko/20081027 SeaMonkey/1.1.12
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Fabio Comolli <fabio.comolli@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jay Fenlason <fenlason@redhat.com>
Subject: Re: Regression in 2.6.28-rc and 2.6.27-stable - hibernate related
References: <b637ec0b0811230817x5b445a0m665305d2b6bf6c1f@mail.gmail.com> <b637ec0b0811231024t73d1b8b3x9e23e24dda94c6b8@mail.gmail.com> <b637ec0b0811231223r2032f221geeb19ea5804d3b91@mail.gmail.com> <200811240031.55944.rjw@sisk.pl>
In-Reply-To: <200811240031.55944.rjw@sisk.pl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Sunday, 23 of November 2008, Fabio Comolli wrote:
>> Hi.
>>
>> On Sun, Nov 23, 2008 at 7:24 PM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
>>> Hi
>>>
>>> Yes. I started another bisection session between 2.6.27.4 and 2.6.27.5.
>>>
>> Ok, this time things went much better. The bisection pointed to:
>>
>> ------------------------------------------------------------------------------------------------------------------------------------------------
>> fcomolli@hawking:~/software/GIT-TREES/linux-2.6.27.y> git bisect good
>> ff0f8d16839cd02dc95bd92c212cbd5d433a4d2b is first bad commit
>> commit ff0f8d16839cd02dc95bd92c212cbd5d433a4d2b
>> Author: Jay Fenlason <fenlason@redhat.com>
>> Date:   Mon Oct 27 23:28:14 2008 +0100
>>
>>     firewire: fix struct fw_node memory leak
>>
>>     commit 77e557191701afa55ae7320d42ad6458a2ad292e upstream
>>
>>     With the bus_resets patch applied, it is easy to see this memory leak
>>     by repeatedly resetting the firewire bus while running slabtop in
>>     another window.  Just watch kmalloc-32 grow and grow...
>>
>>     Signed-off-by: Jay Fenlason <fenlason@redhat.com>
>>     Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
>>
>> :040000 040000 01cadbd5f5fb81ce4f5e2023573204c4fbec3a28
>> 809a53f4be87bd8be133ebd7564e1139a0cfa45b M      drivers
>> ------------------------------------------------------------------------------------------------------------------------------------------------
>>
>> And this is the log:
>>
>> ------------------------------------------------------------------------------------------------------------------------------------------------
>> fcomolli@hawking:~/software/GIT-TREES/linux-2.6.27.y> git bisect log
>> git-bisect start
>> # good: [056c71459d3acf9fefcb2dc67abeef10e649d508] Linux 2.6.27.4
>> git-bisect good 056c71459d3acf9fefcb2dc67abeef10e649d508
>> # bad: [788a5f3f70e2a9c46020bdd3a195f2a866441c5d] Linux 2.6.27.5
>> git-bisect bad 788a5f3f70e2a9c46020bdd3a195f2a866441c5d
>> # bad: [7bdb542c453c14e54af9ebe5c4a827e4a678c47d] powerpc/numa: Make
>> memory reserve code more robust
>> git-bisect bad 7bdb542c453c14e54af9ebe5c4a827e4a678c47d
>> # good: [f29062d0ec12ee3a58c67228dc829574b4ced378] syncookies: fix
>> inclusion of tcp options in syn-ack
>> git-bisect good f29062d0ec12ee3a58c67228dc829574b4ced378
>> # good: [882491755d4c819de5bb593f04d06692185760aa] firewire: fix
>> ioctl() return code
>> git-bisect good 882491755d4c819de5bb593f04d06692185760aa
>> # bad: [baae4f5fd7a75bdfa70d374b738963053df2bcaa] firewire: fw-sbp2: fix races
>> git-bisect bad baae4f5fd7a75bdfa70d374b738963053df2bcaa
>> # bad: [ff0f8d16839cd02dc95bd92c212cbd5d433a4d2b] firewire: fix struct
>> fw_node memory leak
>> git-bisect bad ff0f8d16839cd02dc95bd92c212cbd5d433a4d2b
>> # good: [b6021579f54e5b6b31f03fe24de1208a2feb4aec] firewire: Survive
>> more than 256 bus resets
>> git-bisect good b6021579f54e5b6b31f03fe24de1208a2feb4aec
>> ------------------------------------------------------------------------------------------------------------------------------------------------
>>
>> The commit reverted cleanly and now I'm running 2.6.27.7 with that
>> commit reverted. I'll post my results.
>>
>> Hoper this helps. Regards,
> 
> Yes, thanks for bisecting this (CCs added).

The commit which was pointed to in the bisection does nothing else than
free some data in firewire-core.

(Note to myself and Jay:  See http://lkml.org/lkml/2008/11/23/123 and
http://lkml.org/lkml/2008/11/23/153 for the history of this bug.)

Fabio, please test a _bad_ kernel with firewire drivers unloaded before
hibernation.  Also, please enable in the "Kernel hacking" kernel config
menu:  "Kernel debugging", "Debug slab memory allocations".  Thanks,
-- 
Stefan Richter
-=====-==--- =-== ==---
http://arcgraph.de/sr/
