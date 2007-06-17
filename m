Return-Path: <linux-kernel-owner+w=401wt.eu-S1761081AbXFQXUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761081AbXFQXUh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 19:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756550AbXFQXUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 19:20:30 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:53766 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbXFQXU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 19:20:29 -0400
Date: Mon, 18 Jun 2007 08:18:58 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Carlo Wood <carlo@alinoe.com>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org, eric@anholt.net, zhenyu.z.wang@intel.com,
       y-goto@jp.fujitsu.com, torvalds@linux-foundation.org
Subject: Re: 2.6.22-rc5 regression
Message-ID: <20070617231858.GB27460@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Carlo Wood <carlo@alinoe.com>, Dave Jones <davej@redhat.com>,
	linux-kernel@vger.kernel.org, eric@anholt.net,
	zhenyu.z.wang@intel.com, y-goto@jp.fujitsu.com,
	torvalds@linux-foundation.org
References: <20070617182254.GA17595@alinoe.com> <20070617195805.GA6125@alinoe.com> <20070617214905.GA6207@alinoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070617214905.GA6207@alinoe.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 11:49:05PM +0200, Carlo Wood wrote:
> Kernels that work do NOT print "agpgart: Detected an Intel
> 965G Chipset." (All I know is that I have an ASUS P5B motherboard
> with a iP965, whether it's this 'G' or not I don't know).
> 
The obvious question of course is whether actually reverting this
changeset fixes your problem? I would be very surprised if it did.

If it does make a difference, please provide the values for
CONFIG_HOTPLUG, CONFIG_MEMORY_HOTPLUG and CONFIG_HOTPLUG_CPU from your
.config.

I would wager that you only have CONFIG_HOTPLUG=y, in which case, the
only difference over previous kernels will be that zone_batchlist() is no
longer flagged as __init, and so it won't be freed -- this was the reason
for the "special section" comment in the changeset, as currently it's
left hanging around for folks that aren't doing cpu/memory hotplug, since
__devinit was the closest that both cpu and memory hotplug had in common.

I can't imagine that this would impact you at all, though.
