Return-Path: <linux-kernel-owner+w=401wt.eu-S1757589AbYHNOMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589AbYHNOMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 10:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750757AbYHNOME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 10:12:04 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:38694 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738AbYHNOMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 10:12:03 -0400
Date: Thu, 14 Aug 2008 10:11:56 -0400
To: crane cai <crane.cai@amd.com>
Cc: vojtech@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HPET: Workaround for a BIOS workaround on AMD SB700 platform
Message-ID: <20080814141156.GB12476@csclub.uwaterloo.ca>
References: <1218683616.20466.13.camel@crane-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218683616.20466.13.camel@crane-laptop>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 11:13:36AM +0800, crane cai wrote:
> >From 9bd2f534f986768f1944e626e37af1c323e47dbb Mon Sep 17 00:00:00 2001
> From: Crane Cai <crane.cai@amd.com>
> Date: Thu, 14 Aug 2008 10:31:01 +0800
> Subject: [PATCH] HPET: Workaround for a BIOS workaround on AMD SB700 platform
> 
> On the AMD SB700 southbridge, between the revisions 0x30 to 0x3a, when its
> spread-spectrum frequency modulation feature is enabled, the base frequency
> used by the HPET will not be running on average slower than nominal 14.318
> MHz.

Should that have read "the base frequency used by HPET will on average
be running slower than nominal 14.318 MHz"?  That would be pretty much
the opposite of what the comment says, but makes more sense based on the
rest of the comment, and is a lot simpler to parse.

> Since there is no provision in the OS for HPET to work with properly with
> slower frequency, the BIOS on this platform uses SMM to emulate accesses to
> the HPET config register to supply a corrected base frequency to compensate
> for it.

Seems to have an extra "with" in front of properly.

> However, due to the implementation of the SMM BIOS code, there is a time
> window after the first access to the HPET, which triggers initialization of
> the SMM code, in which the HPET isn't available. Thus it's necessary to wait
> until the HPET emulation is ready, and this is what the patch does on the
> affected machines.

-- 
Len Sorensen
