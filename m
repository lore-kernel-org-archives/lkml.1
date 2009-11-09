Return-Path: <linux-kernel-owner+w=401wt.eu-S1755129AbZKIMiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbZKIMiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 07:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbZKIMiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 07:38:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48609 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228AbZKIMiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 07:38:20 -0500
Date: Mon, 9 Nov 2009 13:38:24 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andre Przywara <andre.przywara@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: x86/NUMA: Reason for ignoring too small NUMA nodes?
Message-ID: <20091109123824.GE26740@basil.fritz.box>
References: <4AF80AA3.9020400@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF80AA3.9020400@amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 01:27:15PM +0100, Andre Przywara wrote:
> while experimenting with a system with a memory-less NUMA node I stumbled 
> upon code in the Linux kernel which ignores nodes containing less than a 
> certain amount of RAM, obviously to fix systems with a buggy BIOS.
> Can you elaborate on this? What kind of incorrect entry have you seen?
> To correctly map the memory less node I did a patch to accept at least 
> nodes with exactly zero bytes of memory (read: no SRAT memory entry), was 
> this special condition also present in the buggy machines?

It was a misparsed numa node, not zero. I don't remember if 
the bug was in Linux or in the BIOS. This was a sanity check
to catch all such cases. I haven't seen misparsed nodes for quite some 
time, so in theory it could be removed I guess.

Zero size node were back then not supported in the VM. I still think
the concept doesn't make too much sense: a memory range without
memory (and it bitrots all the time even today, see recent patches)

-Andi

