Return-Path: <linux-kernel-owner+w=401wt.eu-S1757624AbXFLDfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbXFLDfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 23:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbXFLDfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 23:35:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:59828 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756AbXFLDfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 23:35:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,409,1175497200"; 
   d="scan'208";a="255789181"
Date: Tue, 12 Jun 2007 11:34:25 +0800
From: Wang Zhenyu <zhenyu.z.wang@intel.com>
To: Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       andi@rhlx01.fht-esslingen.de, Keith Packard <keithp@keithp.com>
Subject: Re: [RFC][AGPGART]intel-agp: save whole config space in suspend/resume
Message-ID: <20070612033424.GA30200@zhen-devel.sh.intel.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>, andi@rhlx01.fht-esslingen.de,
	Keith Packard <keithp@keithp.com>
References: <20070612015459.GB28668@zhen-devel.sh.intel.com> <20070612022320.GA2125@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612022320.GA2125@redhat.com>
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.15-1.2054_FC5smp i686
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.11 22:23:21 +0000, Dave Jones wrote:
> 
> I'd feel much safer if we only did this on chipsets where we know we 
> have to do it.   Doing this for *every* Intel chipset ever made _will_
> bite us.  There are some early chipsets (440BX era iirc) that would just
> hang the box when you tried to read from various write-only registers.
> 
> But even on the chipsets where we _do_ need to save/restore something in
> the upper part of the config space, surely it'd be a lot safer
> to just save/restore what we need to rather than risk all sorts
> of mayhem by writing to bits that may trigger hardware events.
> 

I understand. Before James reported his problem on i915, I have thought
the basic restore on that chip should already be enough, but he proved I was
wrong and I'm not sure if this also happens on other i915 board with different
BIOS. 

And with my patch it has already removed the restore cases for 440BX like type,
coz it's gmch_chip_id == 0 and intel_private.pcidev is NULL, so it won't save
extra space on those chips.
