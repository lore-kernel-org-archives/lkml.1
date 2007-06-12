Return-Path: <linux-kernel-owner+w=401wt.eu-S1758162AbXFLCXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162AbXFLCXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 22:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbXFLCX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 22:23:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756837AbXFLCX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 22:23:28 -0400
Date: Mon, 11 Jun 2007 22:23:21 -0400
From: Dave Jones <davej@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>, andi@rhlx01.fht-esslingen.de,
       Keith Packard <keithp@keithp.com>
Subject: Re: [RFC][AGPGART]intel-agp: save whole config space in
	suspend/resume
Message-ID: <20070612022320.GA2125@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>, andi@rhlx01.fht-esslingen.de,
	Keith Packard <keithp@keithp.com>
References: <20070612015459.GB28668@zhen-devel.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612015459.GB28668@zhen-devel.sh.intel.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 09:54:59AM +0800, Wang Zhenyu wrote:

 > It looks that config space save/restore for intel-agp still has problem
 > that might affect some chip models. Andreas Mohr's work on his i815 suspend/resume
 > support showed that we need to save extra bits in config space on this old chip type. 
 > His patch is in -mm tree, http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm2/broken-out/working-3d-dri-intel-agpko-resume-for-i815-chip.patch
 > 
 > And recently James Bottomley also reported that save/restore whole 256 bytes config 
 > space for gfx device can fix his s3 issue on Fujitsu P7120 i915. 
 > http://lists.freedesktop.org/archives/xorg/2007-June/025346.html
 > 
 > So here's my suggested patch for save whole 256 bytes config space for intel-agp,
 > which could fix these issues. I tested it on my 965GM, that s3 works fine with X. 

I'd feel much safer if we only did this on chipsets where we know we 
have to do it.   Doing this for *every* Intel chipset ever made _will_
bite us.  There are some early chipsets (440BX era iirc) that would just
hang the box when you tried to read from various write-only registers.

But even on the chipsets where we _do_ need to save/restore something in
the upper part of the config space, surely it'd be a lot safer
to just save/restore what we need to rather than risk all sorts
of mayhem by writing to bits that may trigger hardware events.

	Dave

-- 
http://www.codemonkey.org.uk
