Return-Path: <linux-kernel-owner+w=401wt.eu-S1759503AbXFRAK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503AbXFRAK5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 20:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbXFRAKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 20:10:50 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:65292 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751377AbXFRAKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 20:10:50 -0400
Date: Mon, 18 Jun 2007 02:10:49 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Paul Mundt <lethal@linux-sh.org>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org, eric@anholt.net, zhenyu.z.wang@intel.com,
       y-goto@jp.fujitsu.com, torvalds@linux-foundation.org
Subject: Re: 2.6.22-rc5 regression
Message-ID: <20070618001049.GB1375@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Paul Mundt <lethal@linux-sh.org>, Dave Jones <davej@redhat.com>,
	linux-kernel@vger.kernel.org, eric@anholt.net,
	zhenyu.z.wang@intel.com, y-goto@jp.fujitsu.com,
	torvalds@linux-foundation.org
References: <20070617182254.GA17595@alinoe.com> <20070617195805.GA6125@alinoe.com> <20070617214905.GA6207@alinoe.com> <20070617231858.GB27460@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070617231858.GB27460@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 08:18:58AM +0900, Paul Mundt wrote:
> The obvious question of course is whether actually reverting this
> changeset fixes your problem? I would be very surprised if it did.

Having a git commit Id, like d09c6b809432668371b5de9102f4f9aa6a7c79cc,
how can I create a .diff file from that?

> If it does make a difference, please provide the values for
> CONFIG_HOTPLUG, CONFIG_MEMORY_HOTPLUG and CONFIG_HOTPLUG_CPU from your
> .config.
> 
> I would wager that you only have CONFIG_HOTPLUG=y, in which case, the
> only difference over previous kernels will be that zone_batchlist() is no
> longer flagged as __init, and so it won't be freed -- this was the reason
> for the "special section" comment in the changeset, as currently it's
> left hanging around for folks that aren't doing cpu/memory hotplug, since
> __devinit was the closest that both cpu and memory hotplug had in common.
> 
> I can't imagine that this would impact you at all, though.

I think git bisect made an error... as you can see for yourself
with the list of tested git Id's that I gave - it didn't test
both sides of that patch imho. If you tell me how to extract a patch
then I'll manually unapply it to some failing kernel revisions and
see if that makes a difference.

-- 
Carlo Wood <carlo@alinoe.com>
