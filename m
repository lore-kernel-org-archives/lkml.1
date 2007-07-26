Return-Path: <linux-kernel-owner+w=401wt.eu-S933697AbXGZWEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933697AbXGZWEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 18:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935638AbXGZWEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 18:04:05 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:53719 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932917AbXGZWED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 18:04:03 -0400
Subject: RE: [PATCH] ia64: fix build failure on fs/quota.c
From: Doug Chapman <doug.chapman@hp.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       vtaras@openvz.org, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>
In-Reply-To: <617E1C2C70743745A92448908E030B2A0205DE5E@scsmsx411.amr.corp.intel.com>
References: <617E1C2C70743745A92448908E030B2A0205DE5E@scsmsx411.amr.corp.intel.com>
Content-Type: text/plain
Date: Thu, 26 Jul 2007 17:58:45 -0400
Message-Id: <1185487125.20910.30.camel@dchapman.boston.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-35.el4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-26 at 14:24 -0700, Luck, Tony wrote:
> This issue wandered off onto a long thread "build fix for x86_64" which
> died out without a final patch.  Here's the summary:
> 

Ahh, thanks, I had not seen that thread.


> > +#if defined(CONFIG_X86_64) || (defined(CONFIG_IA64) && defined(CONFIG_COMPAT))
> 
> It was pointed out that x86-64 also has a CONFIG_COMPAT, so the "right"
> #ifdef mess would be:
> 
> #if defined(CONFIG_COMPAT) && (defined(CONFIG_IA64) || defined(CONFIG_X86_64))
> 
> But this was thought too ugly.  Andi Kleen proposed making a new CONFIG
> variable for this situation: CONFIG_COMPAT_FOR_U64_ALIGMNENT which could
> be set in ia64 and x86-64 Kconfig files with:
> 
> config COMPAT_FOR_U64_ALIGMNENT
> 	def_bool COMPAT
> 
> So the C-code would simply have:
> 
> #if defined(COMPAT_COMPAT_FOR_U64_ALIGMNENT)
> 
> (IIRC the syntax correctly).  Peter Anvin had some worries about future
> issues ... but I think he agreed that this was Ok.
> 
> Anyone still have any objections to this?

No objections here.  I just tried this patch and it does fix my ia64
build issue.  I agree it is a bit cleaner than the long #ifdef.

thanks,

- Doug


