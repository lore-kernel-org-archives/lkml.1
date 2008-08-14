Return-Path: <linux-kernel-owner+w=401wt.eu-S1755048AbYHNOOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbYHNOOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 10:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758598AbYHNOOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 10:14:42 -0400
Received: from styx.suse.cz ([82.119.242.94]:50960 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758225AbYHNOOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 10:14:41 -0400
Date: Thu, 14 Aug 2008 16:14:39 +0200
From: Vojtech Pavlik <vojtech@suse.cz>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: crane cai <crane.cai@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HPET: Workaround for a BIOS workaround on AMD SB700
	platform
Message-ID: <20080814141439.GA14027@suse.cz>
References: <1218683616.20466.13.camel@crane-laptop> <20080814141156.GB12476@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814141156.GB12476@csclub.uwaterloo.ca>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 10:11:56AM -0400, Lennart Sorensen wrote:
> On Thu, Aug 14, 2008 at 11:13:36AM +0800, crane cai wrote:
> > >From 9bd2f534f986768f1944e626e37af1c323e47dbb Mon Sep 17 00:00:00 2001
> > From: Crane Cai <crane.cai@amd.com>
> > Date: Thu, 14 Aug 2008 10:31:01 +0800
> > Subject: [PATCH] HPET: Workaround for a BIOS workaround on AMD SB700 platform
> > 
> > On the AMD SB700 southbridge, between the revisions 0x30 to 0x3a, when its
> > spread-spectrum frequency modulation feature is enabled, the base frequency
> > used by the HPET will not be running on average slower than nominal 14.318
> > MHz.
> 
> Should that have read "the base frequency used by HPET will on average
> be running slower than nominal 14.318 MHz"?  That would be pretty much
> the opposite of what the comment says, but makes more sense based on the
> rest of the comment, and is a lot simpler to parse.

Yes, that is the case.

> > Since there is no provision in the OS for HPET to work with properly with
> > slower frequency, the BIOS on this platform uses SMM to emulate accesses to
> > the HPET config register to supply a corrected base frequency to compensate
> > for it.
> 
> Seems to have an extra "with" in front of properly.
> 
> > However, due to the implementation of the SMM BIOS code, there is a time
> > window after the first access to the HPET, which triggers initialization of
> > the SMM code, in which the HPET isn't available. Thus it's necessary to wait
> > until the HPET emulation is ready, and this is what the patch does on the
> > affected machines.

-- 
Vojtech Pavlik
Director SuSE Labs
