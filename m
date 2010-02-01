Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab0BASlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 13:41:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37146 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228Ab0BASlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 13:41:37 -0500
Message-ID: <4B672059.3070405@zytor.com>
Date: Mon, 01 Feb 2010 10:41:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Michal Simek <michal.simek@petalogix.com>,
       LKML <linux-kernel@vger.kernel.org>,
       John Williams <john.williams@petalogix.com>
Subject: Re: Split 'flush_old_exec' into two functions - 221af7f87b97431e3ee21ce4b0e77d5411cf1549
References: <4B66DE64.8010101@petalogix.com> <alpine.LFD.2.00.1002010741560.4206@localhost.localdomain> <4B671865.5030705@windriver.com>
In-Reply-To: <4B671865.5030705@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2010 10:07 AM, Jason Wessel wrote:
> 
> Add to the afflicted architecture list a ppc64 kernel running 32 bit
> user space apps such as a dynamically linked busybox:
> 
> file bin/busybox
> 
> ELF 32-bit MSB executable, PowerPC or cisco 4500, version 1 (SYSV),
> dynamically linked (uses shared libs), stripped
> 
> 
> All that is reported on boot is:
> 
> [clip]
> VFS: Mounted root (nfs filesystem) readonly on device 0:13.
> Freeing unused kernel memory: 264k freed
> /sbin/init: error while loading shared libraries: out of memory: Cannot
> allocate memory
> Kernel panic - not syncing: Attempted to kill init!
> Rebooting in 180 seconds..QEMU: Terminated
> 

That's is fully to be expected, since PowerPC also does the
TIF_ABI_PENDING garbage, which needs to be removed.

	-hpa
