Return-Path: <linux-kernel-owner+w=401wt.eu-S1751444AbXLEE4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444AbXLEE4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 23:56:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbXLEE4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 23:56:22 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:32607 "EHLO
	mail127-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbXLEE4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 23:56:20 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <47562F69.7010508@am.sony.com>
Date: Tue, 04 Dec 2007 20:56:09 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: Milton Miller <miltonm@bga.com>, Christoph Lameter <clameter@sgi.com>,
       Andy Whitcroft <apw@shadowen.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: PS3: trouble with SPARSEMEM_VMEMMAP and kexec
References: <47537F2E.2070204@am.sony.com> <b91f94dd5b35247fecf52090c0b3890f@bga.com> <Pine.LNX.4.62.0712040925470.16793@pademelon.sonytel.be>
In-Reply-To: <Pine.LNX.4.62.0712040925470.16793@pademelon.sonytel.be>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Dec 2007 04:56:11.0988 (UTC) FILETIME=[283DA940:01C836FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> On Mon, 3 Dec 2007, Milton Miller wrote:
>> Chris, as you can see, PS3 needs to allocate 1/8th of total initial memory to
>> add any more memory.  Geoff, can you predict what linear address the
>> additional memory will occupy?  Judging from the attempted address toa add,
>> maybe not.   If not, my only thought is to pre-reserve an additional page and
>> consume it on the first add.   Additional adds will likely draw from the first
>> added region, pinning.
> 
> To me it sounds a bit strange that hotplug memory relies on having huge
> contiguous blocks of memory available. If this isn't done very early in the
> boot process, changes are high it will fail.
> 
> Would it be possible to allocate the memory from the newly added block, which
> is guaranteed to be unfragmented?


Yes, this sounds like a cleaner solution than pre-allocating, as the memory is
there and its properties are known.

-Geoff


