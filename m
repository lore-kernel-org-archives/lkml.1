Return-Path: <linux-kernel-owner+w=401wt.eu-S1763774AbXLNXTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763774AbXLNXTi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 18:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934137AbXLNXTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 18:19:15 -0500
Received: from colin.muc.de ([193.149.48.1]:3047 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932445AbXLNXTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 18:19:13 -0500
Date: 15 Dec 2007 00:19:11 +0100
Date: Sat, 15 Dec 2007 00:19:11 +0100
From: Andi Kleen <ak@muc.de>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland Dreier <rdreier@cisco.com>, venkatesh.pallipadi@intel.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 06/12] PAT 64b: Add ioremap_wc support
Message-ID: <20071214231911.GA99967@muc.de>
References: <20071213235543.568682000@intel.com> <20071213235712.339088000@intel.com> <ada8x3x7vw5.fsf@cisco.com> <m1sl25q4rc.fsf@ebiederm.dsl.xmission.com> <ada4pel7v6a.fsf@cisco.com> <m1odctq3tn.fsf@ebiederm.dsl.xmission.com> <20071214214026.GC717@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071214214026.GC717@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For now, we don't track RAM pages using memattr infrastructure. This is because,
> memattr infrastructure is not enough. i.e., while the page is getting
> tracked using memattr infrastructure,

> potentially the page can get
> freed(a bug that we need to catch, to avoid attribute aliasing).

That would be a bug in the caller. But anybody who sets non standard
attributes should go through memattr first.

The only exception is /dev/mem -- not sure how to handle this best.
Perhaps only allow memattr for non memory for there. 

-Andi
