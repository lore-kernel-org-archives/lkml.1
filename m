Return-Path: <linux-kernel-owner+w=401wt.eu-S1760025AbXI0Wdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760025AbXI0Wdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 18:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759023AbXI0Wda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 18:33:30 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:43066 "EHLO
	outbound1-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758762AbXI0Wd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 18:33:29 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
Date: Thu, 27 Sep 2007 16:33:36 -0600
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: jkeating@redhat.com, "Joerg Pommnitz" <pommnitz@yahoo.com>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <ak@suse.de>
Subject: Re: More E820 brokenness
Message-ID: <20070927223336.GB4755@cosmic.amd.com>
References: <46FC2BFD.6070200@zytor.com>
MIME-Version: 1.0
In-Reply-To: <46FC2BFD.6070200@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 27 Sep 2007 22:33:07.0420 (UTC)
 FILETIME=[6047E9C0:01C80156]
X-WSS-ID: 6AE2F0292ZC500270-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/09/07 15:17 -0700, H. Peter Anvin wrote:
> As luck would have it, it's not just an obscure Geode system which has a
> broken E820 implementation.  Today I received a bug report about a Dell
> system (XPS M1330) with broken E820.
> 
> Unfortunately, the workaround for the Geode breaks this system, because
> x86-64 doesn't fall back to the e801/88 information like the i386 kernel
> does.
> 
> I wonder if the relevant people could test out this patch to see how it
> works on their respective system.  This patch reverts to 2.6.23-rc8
> behaviour of simply truncating the map, but still makes e801/88 info
> available to the kernel; this hopefully should match 2.6.22 behaviour.

Breaks on the Geode - original behavior.

I think that having boot_prams.e820_entries != 0 makes the kernel
assume the e820 data is correct.

> I want to emphasize that this is seriously broken.  Using a partial e820
> map could have disastrous results, since the kernel will have partial
> memory map information and not know about reserved areas, etc.  Part of
> me feels that the right thing to do is what the current git kernel does
> -- either fall back to e801, or stop and error.

I'm inclined to agree.  

Jordan


