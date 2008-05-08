Return-Path: <linux-kernel-owner+w=401wt.eu-S1763843AbYEHQUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763843AbYEHQUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 12:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbYEHQUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 12:20:35 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:1058 "EHLO
	outbound2-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750852AbYEHQUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 12:20:33 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0K0K5DR-04-NER-01
Date: Thu, 8 May 2008 18:19:25 +0200
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Nishanth Aravamudan <nacc@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] x86: fix PAE pmd_bad bootup warning
Message-ID: <20080508161925.GH12654@escobedo.amd.com>
References: <20080506124946.GA2146@elte.hu> <Pine.LNX.4.64.0805061435510.32567@blonde.site> <alpine.LFD.1.10.0805061138580.32269@woody.linux-foundation.org> <Pine.LNX.4.64.0805062043580.11647@blonde.site> <20080506202201.GB12654@escobedo.amd.com> <1210106579.4747.51.camel@nimitz.home.sr71.net> <20080508143453.GE12654@escobedo.amd.com> <1210258350.7905.45.camel@nimitz.home.sr71.net> <20080508151145.GG12654@escobedo.amd.com> <1210261882.7905.49.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210261882.7905.49.camel@nimitz.home.sr71.net>
User-Agent: Mutt/1.4.2.3i
X-OriginalArrivalTime: 08 May 2008 16:19:24.0141 (UTC) FILETIME=[477F11D0:01C8B127]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 08:51:22AM -0700, Dave Hansen wrote:
> Is there anything in your dmesg?

mm/memory.c:127: bad pmd ffff810076801040(80000000720000e7).

> There was a discussion on LKML in the last couple of days about
> pmd_bad() triggering on huge pages.  Perhaps we're clearing the mapping
> with the pmd_none_or_clear_bad(), and *THAT* is leaking the page.

That makes sense. I remember that explicitly munmapping the huge page
would still work, but it doesn't. I don't quite remember what I did back
then to test this, but I probably made some mistake there that led me to
some false conclusions.


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

