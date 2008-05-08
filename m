Return-Path: <linux-kernel-owner+w=401wt.eu-S1758730AbYEHOfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730AbYEHOfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 10:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbYEHOfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 10:35:18 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:32358 "EHLO
	outbound9-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753277AbYEHOfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 10:35:16 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0K0K0I1-03-P9M-01
Date: Thu, 8 May 2008 16:34:53 +0200
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
Message-ID: <20080508143453.GE12654@escobedo.amd.com>
References: <b6a2187b0805051806v25fa1272xb08e0b70b9c3408@mail.gmail.com> <20080506124946.GA2146@elte.hu> <Pine.LNX.4.64.0805061435510.32567@blonde.site> <alpine.LFD.1.10.0805061138580.32269@woody.linux-foundation.org> <Pine.LNX.4.64.0805062043580.11647@blonde.site> <20080506202201.GB12654@escobedo.amd.com> <1210106579.4747.51.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210106579.4747.51.camel@nimitz.home.sr71.net>
User-Agent: Mutt/1.4.2.3i
X-OriginalArrivalTime: 08 May 2008 14:34:51.0640 (UTC) FILETIME=[ACCB5F80:01C8B118]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 01:42:59PM -0700, Dave Hansen wrote:
> Could you post the code you're using to do this?  I have to wonder if
> you're leaving a fd open somewhere.  Even if you rm the hugepage file,
> it'll stay allocated if you have a fd open, or if *someone* is still
> mapping it. 

A stripped-down program exposing the leak is attached. It doesn't fork
or do any other fancy stuff, so I don't see a way it could leave any fd
open.

While trying to reproduce this, I noticed that the huge page wouldn't
leak when I just mmapped it and exited without explicitly unmapping, as
I described before. The huge page is leaked only when the
/proc/self/pagemap entry for the huge page is read. The kernel I tested
with was 2.6.26-rc1-00179-g3de2403.

> Can you umount your hugetlbfs?

Yes, but the pages remain lost.

Hans


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

