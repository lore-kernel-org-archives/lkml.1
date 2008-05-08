Return-Path: <linux-kernel-owner+w=401wt.eu-S1758940AbYEHPMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbYEHPMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 11:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754685AbYEHPMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 11:12:42 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:22587 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753341AbYEHPMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 11:12:41 -0400
X-BigFish: VP
X-WSS-ID: 0K0K28Q-04-JCH-01
Date: Thu, 8 May 2008 17:11:45 +0200
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Nishanth Aravamudan <nacc@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] x86: fix PAE pmd_bad bootup warning
Message-ID: <20080508151145.GG12654@escobedo.amd.com>
References: <b6a2187b0805051806v25fa1272xb08e0b70b9c3408@mail.gmail.com> <20080506124946.GA2146@elte.hu> <Pine.LNX.4.64.0805061435510.32567@blonde.site> <alpine.LFD.1.10.0805061138580.32269@woody.linux-foundation.org> <Pine.LNX.4.64.0805062043580.11647@blonde.site> <20080506202201.GB12654@escobedo.amd.com> <1210106579.4747.51.camel@nimitz.home.sr71.net> <20080508143453.GE12654@escobedo.amd.com> <1210258350.7905.45.camel@nimitz.home.sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1210258350.7905.45.camel@nimitz.home.sr71.net>
User-Agent: Mutt/1.4.2.3i
X-OriginalArrivalTime: 08 May 2008 15:11:42.0998 (UTC) FILETIME=[D2DDD360:01C8B11D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 07:52:30AM -0700, Dave Hansen wrote:
> On Thu, 2008-05-08 at 16:34 +0200, Hans Rosenfeld wrote:
> > The huge page is leaked only when the
> > /proc/self/pagemap entry for the huge page is read.
> 
> Well, that's an interesting data point! :)
> 
> Are you running any of your /proc/<pid>/pagemap patches?

No additional patches. The problem already existed before we agreed on
the change to the pagemap code to just include the page size in the
values returned, and not doing any special huge page handling. I suspect
the page walking code used by /proc/pid/pagemap is doing something nasty
when it sees a huge page as it doesn't know how to handle it.


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

