Return-Path: <linux-kernel-owner+w=401wt.eu-S1755697AbZFEQ4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbZFEQ4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 12:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbZFEQ4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 12:56:07 -0400
Received: from mga07.intel.com ([143.182.124.22]:49167 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752743AbZFEQ4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 12:56:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,312,1241420400"; 
   d="scan'208";a="151147305"
Date: Fri, 5 Jun 2009 18:58:14 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: pHilipp Zabel <philipp.zabel@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] MFD: ASIC3: add clock handling for MFD cells
Message-ID: <20090605165813.GC1039@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <1244140576-18006-1-git-send-email-philipp.zabel@gmail.com> <1244140576-18006-3-git-send-email-philipp.zabel@gmail.com> <20090604234911.GC5460@sortiz.org> <74d0deb30906050927i428f732ehc76ac592c87d44b3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <74d0deb30906050927i428f732ehc76ac592c87d44b3@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 06:27:20PM +0200, pHilipp Zabel wrote:
> On Fri, Jun 5, 2009 at 1:49 AM, Samuel Ortiz<sameo@openedhand.com> wrote:
> > Hi Philipp,
> >
> > On Thu, Jun 04, 2009 at 08:36:11PM +0200, Philipp Zabel wrote:
> >> +
> >> +struct asic3_clk {
> >> +     int enabled;
> > You probably want to use a kref here.
> >
> >> +static int asic3_clk_enable(struct asic3 *asic, struct asic3_clk *clk)
> >> +{
> >> +     unsigned long flags;
> >> +     u32 cdex;
> >> +
> >> +     spin_lock_irqsave(&asic->lock, flags);
> >> +     if (clk->enabled++ == 0) {
> > using the kref API here would definitely be nicer.
> 
> While I agree that the kref API looks nice, I'm not convinced it is
> intended to be used in this case. We are not counting references here.
> There is no way to get the count back from the API, which we need to
> decide whether or not to flip the CDEX bits. 
Fair enough.


> We could misuse the
> release function pointer given to kref_put to turn off the clock, but
> I'd prefer to leave it the way it is now.
That's fine with me.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
