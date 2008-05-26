Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbYEZPvC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbYEZPvC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 11:51:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbYEZPuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 11:50:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51172 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbYEZPuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 11:50:50 -0400
Date: Mon, 26 May 2008 08:50:00 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, venkatesh.pallipadi@intel.com,
       suresh.b.siddha@intel.com, Michael Neuling <mikey@neuling.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v1 0/3] Scaled statistics using APERF/MPERF in x86
Message-ID: <20080526085000.33787eac@infradead.org>
In-Reply-To: <20080526142513.24680.97164.stgit@drishya.in.ibm.com>
References: <20080526142513.24680.97164.stgit@drishya.in.ibm.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008 20:01:33 +0530
Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:

> The following RFC patch tries to implement scaled CPU utilisation
> statistics using APERF and MPERF MSR registers in an x86 platform.
> 
> The CPU capacity is significantly changed when the CPU's frequency is
> reduced for the purpose of power savings.  The applications that run
> at such lower CPU frequencies are also accounted for real CPU time by
> default.  If the applications have been run at full CPU frequency,
> they would have finished the work faster and not get charged for
> excessive CPU time.
> 
> One of the solution to this problem it so scale the utime and stime
> entitlement for the process as per the current CPU frequency.  This
> technique is used in powerpc architecture with the help of hardware
> registers that accurately capture the entitlement.
> 

there are some issues with this unfortunately, and these make it
a very complex thing to do. 
Just to mention a few:
1) What if the BIOS no longer allows us to go to the max frequency for
a period (for example as a result of overheating); with the approach
above, the admin would THINK he can go faster, but he cannot in reality,
so there's misleading information (the system looks half busy, while in
reality it's actually the opposite, it's overloaded). Management tools
will take the wrong decisions (such as moving MORE work to the box, not
less)
2) On systems with Intel Dynamic Acceleration technology, you can get
over 100% of cycles this way. (For those who don't know what IDA is;
IDA is basically a case where if your Penryn based dual core laptop is
only using 1 core, the other core can go faster than 100% as long as
thermals etc allow it). How do you want to deal with this?
