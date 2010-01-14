Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696Ab0ANJZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab0ANJZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 04:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756663Ab0ANJZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 04:25:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51743 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662Ab0ANJZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 04:25:17 -0500
Date: Thu, 14 Jan 2010 10:25:15 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Yinghai Lu <yinghai@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2 5/5] x86: use dmi check to treat disabled cpus as
	hotplug cpus.
Message-ID: <20100114092515.GG12241@basil.fritz.box>
References: <1263338274-6485-5-git-send-email-yinghai@kernel.org> <1263340563.2854.1011.camel@sbs-t61.sc.intel.com> <4B4D0E39.10200@kernel.org> <87tyupfzk8.fsf@basil.nowhere.org> <4B4E427D.9090207@zytor.com> <20100113222348.GE24818@basil.fritz.box> <4B4E48BB.5030902@zytor.com> <1263421753.2865.103.camel@sbs-t61.sc.intel.com> <4B4E4AE3.1030608@zytor.com> <1263422958.2865.107.camel@sbs-t61.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263422958.2865.107.camel@sbs-t61.sc.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 02:49:18PM -0800, Suresh Siddha wrote:
> On Wed, 2010-01-13 at 14:36 -0800, H. Peter Anvin wrote:
> > On 01/13/2010 02:29 PM, Suresh Siddha wrote:
> > >>
> > >> Well, that *is* working around broken code, in this case the broken code
> > >> is the percpu allocation strategy.
> > > 
> > > Andi, Recently percpu folks changed the per-cpu static first chunk to
> > > PMD SIZE right. I think that is what causing all this issue.
> > > 
> > 
> > Please don't tell me we're allocating 2 MB per CPU and throwing away
> > most of it...
> 
> Looking at the percpu code, they do seem to free the unused memory in
> that hole.

I took a look at alloc_percpu() at least and it seems to always
allocate for all possible cpus.

Unfortunately we don't have a nice accounting mechanism for it in /proc,
perhaps we should. So it's unclear right now if that is a problem or not.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
