Return-Path: <linux-kernel-owner+w=401wt.eu-S1758773AbZAIWsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbZAIWsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 17:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZAIWsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 17:48:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:49568 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbZAIWsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 17:48:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,241,1231142400"; 
   d="scan'208";a="480455561"
Date: Fri, 9 Jan 2009 14:48:04 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tvignaud@mandriva.com" <tvignaud@mandriva.com>
Subject: Re: [patch] x86, pat: fix reserve_memtype() for legacy 1MB range
Message-ID: <20090109224804.GD6472@linux-os.sc.intel.com>
References: <20090109223520.GC6472@linux-os.sc.intel.com> <4967D223.1090703@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4967D223.1090703@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2009 at 02:39:31PM -0800, H. Peter Anvin wrote:
> Suresh Siddha wrote:
> >
> > Here X is trying to map first 8KB of memory using /dev/mem. Existing
> > code treats first 0-4KB of memory as non-RAM and 4KB-8KB as RAM. Recent
> > code changes don't allow to map memory with different attributes
> > at the same time.
> >
> 
> Why was 0-4 KB marked as non-RAM?  It is most definitely RAM, and should
> be WB.

While in reality it is RAM, we have CONFIG_STRICT_DEVMEM which doesn't allow
apps to map RAM pages using /dev/mem. And to allow app's to map the
legacy 0-4KB bios data page, we consider it as non-RAM.

thanks,
suresh
