Return-Path: <linux-kernel-owner+w=401wt.eu-S1755794AbZAIXNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbZAIXNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbZAIXNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:13:21 -0500
Received: from mga03.intel.com ([143.182.124.21]:10717 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859AbZAIXNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:13:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,241,1231142400"; 
   d="scan'208";a="98420017"
Date: Fri, 9 Jan 2009 15:13:16 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tvignaud@mandriva.com" <tvignaud@mandriva.com>
Subject: Re: [patch] x86, pat: fix reserve_memtype() for legacy 1MB range
Message-ID: <20090109231316.GE6472@linux-os.sc.intel.com>
References: <20090109223520.GC6472@linux-os.sc.intel.com> <4967D223.1090703@zytor.com> <20090109224804.GD6472@linux-os.sc.intel.com> <4967D5FB.5020302@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4967D5FB.5020302@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2009 at 02:55:55PM -0800, H. Peter Anvin wrote:
> Suresh Siddha wrote:
> > On Fri, Jan 09, 2009 at 02:39:31PM -0800, H. Peter Anvin wrote:
> >> Suresh Siddha wrote:
> >>> Here X is trying to map first 8KB of memory using /dev/mem. Existing
> >>> code treats first 0-4KB of memory as non-RAM and 4KB-8KB as RAM. Recent
> >>> code changes don't allow to map memory with different attributes
> >>> at the same time.
> >>>
> >> Why was 0-4 KB marked as non-RAM?  It is most definitely RAM, and should
> >> be WB.
> > 
> > While in reality it is RAM, we have CONFIG_STRICT_DEVMEM which doesn't allow
> > apps to map RAM pages using /dev/mem. And to allow app's to map the
> > legacy 0-4KB bios data page, we consider it as non-RAM.
> 
> Permission to map and memory type should not be connected.  Just to 
> clarify, when mapped, was it still WB?

yes it is. It's just treated and tracked differently.
