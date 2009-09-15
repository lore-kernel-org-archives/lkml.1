Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbZIOOoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbZIOOoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 10:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbZIOOoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 10:44:13 -0400
Received: from fifo99.com ([67.223.236.141]:41036 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238AbZIOOoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 10:44:12 -0400
Subject: Re: [PATCH v3 1/3] pSeries: cede latency specifier helper function.
From: Daniel Walker <dwalker@fifo99.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       "Darrick J. Wong" <djwong@us.ibm.com>
In-Reply-To: <20090915120701.20523.94109.stgit@sofia.in.ibm.com>
References: <20090915120629.20523.79019.stgit@sofia.in.ibm.com>
	 <20090915120701.20523.94109.stgit@sofia.in.ibm.com>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 07:45:05 -0700
Message-Id: <1253025905.11643.335.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 17:37 +0530, Gautham R Shenoy wrote:
>         // Used to pass parms from the OS to PLIC for SetAsrAndRfid
>         u64     saved_gpr3;             // Saved GPR3                   x20-x27
>         u64     saved_gpr4;             // Saved GPR4                   x28-x2F
> -       u64     saved_gpr5;             // Saved GPR5                   x30-x37
> +       union {
> +               u64     saved_gpr5;     // Saved GPR5                   x30-x37
> +               struct {
> +                       u8      cede_latency_hint;  //                  x30
> +                       u8      reserved[7];        //                  x31-x36
> +               } fields;
> +       } gpr5_dword;
> +
>  
>         u8      dtl_enable_mask;        // Dispatch Trace Log mask      x38-x38
>         u8      donate_dedicated_cpu;   // Donate dedicated CPU cycles  x39-x39

Could you drop the C99 style comments (use /* */ instead)? If you run
checkpatch on this it will error on these lines..

Daniel

