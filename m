Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab0BASIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 13:08:14 -0500
Received: from mail.windriver.com ([147.11.1.11]:54014 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab0BASIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 13:08:13 -0500
Message-ID: <4B671865.5030705@windriver.com>
Date: Mon, 01 Feb 2010 12:07:33 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Michal Simek <michal.simek@petalogix.com>,
       LKML <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       John Williams <john.williams@petalogix.com>
Subject: Re: Split 'flush_old_exec' into two functions - 221af7f87b97431e3ee21ce4b0e77d5411cf1549
References: <4B66DE64.8010101@petalogix.com> <alpine.LFD.2.00.1002010741560.4206@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002010741560.4206@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Feb 2010 18:07:33.0285 (UTC) FILETIME=[6D395D50:01CAA369]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Mon, 1 Feb 2010, Michal Simek wrote:
>   
>> Hi Peter and Linus,
>>
>> commit 221af7f87b97431e3ee21ce4b0e77d5411cf1549 breaks anything on Microblaze.
>>     
>
> Are the failing binaries all setuid ones, for example? Or shared vs 
> non-shared? Or ELF vs FLAT or whatever?
>   

Add to the afflicted architecture list a ppc64 kernel running 32 bit
user space apps such as a dynamically linked busybox:

file bin/busybox

ELF 32-bit MSB executable, PowerPC or cisco 4500, version 1 (SYSV),
dynamically linked (uses shared libs), stripped


All that is reported on boot is:

[clip]
VFS: Mounted root (nfs filesystem) readonly on device 0:13.
Freeing unused kernel memory: 264k freed
/sbin/init: error while loading shared libraries: out of memory: Cannot
allocate memory
Kernel panic - not syncing: Attempted to kill init!
Rebooting in 180 seconds..QEMU: Terminated


Reverting the patch solves the problem.

Jason.
