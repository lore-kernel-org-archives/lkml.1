Return-Path: <linux-kernel-owner+w=401wt.eu-S1765701AbYEHQwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765701AbYEHQwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 12:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758134AbYEHQwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 12:52:06 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:58373 "EHLO
	outbound6-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754080AbYEHQwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 12:52:04 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0K0K6UD-03-3ML-01
Date: Thu, 8 May 2008 18:51:11 +0200
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, Hugh Dickins <hugh@veritas.com>,
       Ingo Molnar <mingo@elte.hu>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] x86: fix PAE pmd_bad bootup warning
Message-ID: <20080508165111.GI12654@escobedo.amd.com>
References: <alpine.LFD.1.10.0805061138580.32269@woody.linux-foundation.org> <Pine.LNX.4.64.0805062043580.11647@blonde.site> <20080506202201.GB12654@escobedo.amd.com> <1210106579.4747.51.camel@nimitz.home.sr71.net> <20080508143453.GE12654@escobedo.amd.com> <1210258350.7905.45.camel@nimitz.home.sr71.net> <20080508151145.GG12654@escobedo.amd.com> <1210261882.7905.49.camel@nimitz.home.sr71.net> <20080508161925.GH12654@escobedo.amd.com> <20080508163352.GN23990@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508163352.GN23990@us.ibm.com>
User-Agent: Mutt/1.4.2.3i
X-OriginalArrivalTime: 08 May 2008 16:51:08.0687 (UTC) FILETIME=[B6B1B9F0:01C8B12B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 09:33:52AM -0700, Nishanth Aravamudan wrote:
> So this seems to lend credence to Dave's hypothesis. Without, as you
> were trying before, teaching pagemap all about hugepages, what are our
> options?
> 
> Can we just skip over the current iteration of the PMD loop (would we
> need something similar for the PTE loop for power?) if pmd_huge(pmd)?

Allowing huge pages in the page walker would affect both walk_pmd_range
and walk_pud_range. Then either the users of the page walker need to
know how to handle huge pages themselves (in the pmd_entry and pud_entry
callback functions), or the page walker treats huge pages as any other
pages (calling the pte_entry callback function).


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

