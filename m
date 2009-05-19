Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbZESM4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbZESM4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 08:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbZESM4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 08:56:36 -0400
Received: from www.tglx.de ([62.245.132.106]:60840 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054AbZESM4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 08:56:32 -0400
Date: Tue, 19 May 2009 14:55:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Shaohua Li <shaohua.li@intel.com>
cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, lenb@kernel.org,
       thisistempbox@yahoo.com, mingo@redhat.com
Subject: Re: [PATCH 1/2]cpuidle: makes AMD C1E works in acpi_idle
In-Reply-To: <20090519080942.GA12117@sli10-desk.sh.intel.com>
Message-ID: <alpine.LFD.2.00.0905191447490.5983@localhost.localdomain>
References: <20090519080942.GA12117@sli10-desk.sh.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 May 2009, Shaohua Li wrote:

> When AMD C1E is enabled, local APIC timer will stop even in C1. This patch uses
> broadcast ipi to replace local APIC timer in C1.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=13233

Hmm. This was addressed before in 

commit a8d6829044901a67732904be5f1eacdf8539604f (x86: prevent C-states
hang on AMD C1E enabled machines)

We limit C-States to 1 via acpi_processor_cstate_check().

And we have the broadcast logic in c1e_idle() already. We also select
c1e_idle as the idle routine, so why is the ACPI code not using this. ?

Thanks,

	tglx
