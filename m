Return-Path: <linux-kernel-owner+w=401wt.eu-S1759285AbXFSXo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285AbXFSXo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 19:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbXFSXoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 19:44:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730AbXFSXoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 19:44:22 -0400
Date: Tue, 19 Jun 2007 19:44:07 -0400
From: Dave Jones <davej@redhat.com>
To: Carlo Wood <carlo@alinoe.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, eric@anholt.net, zhenyu.z.wang@intel.com,
       lethal@linux-sh.org, y-goto@jp.fujitsu.com
Subject: Re: 2.6.22-rc5 regression
Message-ID: <20070619234407.GB12096@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Carlo Wood <carlo@alinoe.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, eric@anholt.net,
	zhenyu.z.wang@intel.com, lethal@linux-sh.org, y-goto@jp.fujitsu.com
References: <20070617195805.GA6125@alinoe.com> <20070617214905.GA6207@alinoe.com> <alpine.LFD.0.98.0706180950130.14121@woody.linux-foundation.org> <20070618181225.GB8054@alinoe.com> <alpine.LFD.0.98.0706181127380.14121@woody.linux-foundation.org> <20070618195415.GA7481@alinoe.com> <alpine.LFD.0.98.0706181332400.3593@woody.linux-foundation.org> <20070618225009.GE13538@alinoe.com> <alpine.LFD.0.98.0706181553450.3593@woody.linux-foundation.org> <20070619233716.GA5779@alinoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070619233716.GA5779@alinoe.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 01:37:16AM +0200, Carlo Wood wrote:

 > Personally I am convinced that the real problem is with
 > 8888985144db8f4cb7e56154b31bdf233d3550bf
 > 
 >     [AGPGART] intel_agp: fix device probe
 >     
 >     This patch trys to fix device probe in two cases. First we should
 >     correctly detect device if integrated graphics device is not enabled
 >     or exists, like an add-in card is plugged. Second on some type of intel
 >     GMCH, it might have multiple graphic chip models, like 945GME case, so
 >     we should be sure the detect works through the whole table.
 >     
 >     Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>
 >     Signed-off-by: Dave Jones <davej@redhat.com>
 > 
 > 
 > The result of this patch is that the kernel starts to print
 > "agpgart: Detected an Intel 965G Chipset." again with the usual
 > disastrous results. Now, that doesn't mean that this patch is
 > wrong - but it explains why the problem returns after this patch.

Right, without this patch, probing was broken, so we never matched
an agp driver to the chipset.  The question remains though, why
the initialisation of the chip is so broken.

	Dave

-- 
http://www.codemonkey.org.uk
