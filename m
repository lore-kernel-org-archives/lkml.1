Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755Ab0AZUws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab0AZUws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 15:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554Ab0AZUwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 15:52:47 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:43656 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab0AZUwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 15:52:46 -0500
Message-ID: <4B5F54DE.7030302@nortel.com>
Date: Tue, 26 Jan 2010 14:47:26 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: which fields in /proc/meminfo are orthogonal?
References: <4B5F3C9C.3050908@nortel.com>
In-Reply-To: <4B5F3C9C.3050908@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jan 2010 20:52:28.0241 (UTC) FILETIME=[78995410:01CA9EC9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2010 01:03 PM, Chris Friesen wrote:

> I'm currently trying to figure out which of the entries in /proc/meminfo
> are actually orthogonal to each other.  Ideally I'd like to be able to
> add up the suitable entries and have it work out to the total memory on
> the system, so that I can then narrow down exactly where the memory is
> going.  Is this feasable?

I've tried adding up
MemFree+Buffers+Cached+AnonPages+Mapped+Slab+PageTables+VmallocUsed

(hugepages are disabled and there is no swap)

Shortly after boot this gets me within about 3MB of MemTotal.  However,
after 1070 minutes there is a 64MB difference between MemTotal and the
above sum.

Here's /proc/meminfo after 1070 minutes:

MemTotal:      4042848 kB
MemFree:        406112 kB
Buffers:         12072 kB
Cached:        3068368 kB
SwapCached:          0 kB
Active:         671200 kB
Inactive:      2711952 kB
SwapTotal:           0 kB
SwapFree:            0 kB
Dirty:              44 kB
Writeback:           0 kB
AnonPages:      235864 kB
Mapped:          30752 kB
Slab:           200156 kB
SReclaimable:   142828 kB
SUnreclaim:      57328 kB
PageTables:       4320 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
WritebackTmp:        0 kB
CommitLimit:   2021424 kB
Committed_AS:  2593116 kB
VmallocTotal: 34359738367 kB
VmallocUsed:     21496 kB
VmallocChunk: 34359716779 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
HugePages_Surp:      0
Hugepagesize:     2048 kB
DirectMap4k:      3008 kB
DirectMap2M:   4190208 kB

Any ideas how to track down the missing memory?

Chris
