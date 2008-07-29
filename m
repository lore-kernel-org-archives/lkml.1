Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbYG2IEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbYG2IEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 04:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbYG2IDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 04:03:35 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:30495 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbYG2IDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 04:03:32 -0400
X-BigFish: VPS-35(zz1432R98dR1805M936fQ9371Mzz10d3izzz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K4RD1I-04-7D6-01
Date: Tue, 29 Jul 2008 10:02:51 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/5] x86 cleanup: convert round_up() to roundup()
Message-ID: <20080729080251.GB11548@amd.com>
References: <1216997339-31427-1-git-send-email-joerg.roedel@amd.com> <20080726133932.GB4401@elte.hu> <86802c440807282341g65c90f10gbdcf72beecdd0852@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <86802c440807282341g65c90f10gbdcf72beecdd0852@mail.gmail.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 29 Jul 2008 08:02:51.0617 (UTC) FILETIME=[7FA42D10:01C8F151]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 11:41:27PM -0700, Yinghai Lu wrote:
> On Sat, Jul 26, 2008 at 6:39 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Joerg Roedel <joerg.roedel@amd.com> wrote:
> >
> >> The x86 architecture declares its own round_up macro. But there is a
> >> generic one in <linux/kernel.h> which can also be used. This patchset
> >> replaces the x86 round_up() macro with the generic roundup() one where
> >> possible. The patches have been compile-tested for 32 and 64 bit and
> >> boot-tested for 64 bit. If we can fix the other places too we can get
> >> rid of the x86 specific round_up() in the future.
> >
> > applied to tip/x86/cleanups - thanks Joerg!
> >
> these patches looks like some backward, aka wrong direction.
> 
> #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
> 
> #define round_up(x, y) (((x) + (y) - 1) & ~((y) - 1))
> #define round_down(x, y) ((x) & ~((y) - 1))
> 
> round_up looks more efficient.

It may be more efficient depending on the compiler optimizations. The
other problem with the x86 round_up is that it only works when rounding to
multiples of power of 2. This behavior is not represented in the macro
name and also the generic roundup macro does not have this problem.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

