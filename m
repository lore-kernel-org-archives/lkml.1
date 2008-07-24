Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbYGXU1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbYGXU1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 16:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbYGXU1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 16:27:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:10781 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbYGXU13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 16:27:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,248,1215414000"; 
   d="scan'208";a="421764704"
Date: Thu, 24 Jul 2008 13:27:28 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] x64, fpu: fix possible FPU leakage in error conditions
Message-ID: <20080724202728.GL14380@linux-os.sc.intel.com>
References: <20080724180429.GI14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241122260.3237@nehalem.linux-foundation.org> <20080724185053.GJ14380@linux-os.sc.intel.com> <alpine.LFD.1.10.0807241154260.3237@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807241154260.3237@nehalem.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 11:59:03AM -0700, Linus Torvalds wrote:
> 
> On Thu, 24 Jul 2008, Suresh Siddha wrote:
> >
> > If we don't do init_fpu() + restore from the sane init state, process has
> > to be killed, in the paranoid failing scenario of math_state_restore()
> 
> Umm. I'm still not seeing why the right answer is not just to do "stts +
> math_used = 0".
> 
> And the specific case of math_state_restore(), that will also fix the
> problem - next time around.

Ok.

> As far as I can tell, your patch causes serious problems in case
> init_fpu() fails. Which it can do, afaik.

Only the first init_fpu() can fail (memory allocation failure). But here,
it is def not the first time.

Anyhow, your suggestion is simple and clean. Will post the patch shortly.

I have to do clear_fpu() though(stts + math_used = 0 may not be enough).

thanks,
suresh
