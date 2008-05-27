Return-Path: <linux-kernel-owner+w=401wt.eu-S1756495AbYE0OTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495AbYE0OTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 10:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036AbYE0OTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 10:19:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59776 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878AbYE0OTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 10:19:37 -0400
Date: Tue, 27 May 2008 07:19:00 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: svaidy@linux.vnet.ibm.com
Cc: balbir@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       Michael Neuling <mikey@neuling.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v1 0/3] Scaled statistics using APERF/MPERF in x86
Message-ID: <20080527071900.25329ae1@infradead.org>
In-Reply-To: <20080527132909.GC5181@dirshya.in.ibm.com>
References: <20080526142513.24680.97164.stgit@drishya.in.ibm.com>
	<20080526085000.33787eac@infradead.org>
	<483AF25B.6090806@linux.vnet.ibm.com>
	<20080526110040.5ddc4656@infradead.org>
	<483B0348.2000204@linux.vnet.ibm.com>
	<20080526115108.6a19e2c0@infradead.org>
	<20080527132909.GC5181@dirshya.in.ibm.com>
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

\> > 
> > that's a case where it really makes sense; it's the case where the
> > thing that controls the cpu P-state actually learns about how much
> > work was done to reevaluate what the cpu frequency should be going
> > forward. Eg it's a case of comparing actual frequency (APERF/MPERF)
> > to see what's useful to set next.
> > IDA makes this all needed due to the dynamic nature of the concept
> > of "frequency".
> 
> Scaled statistics relative to maximum CPU capacity is just a method of
> exposing the actual CPU utilisation of applications independent of CPU
> frequency changes.
> 
> Reason behind the metric is same as the above fact that you have
> mentioned.  The CPU frequency governors cannot make decisions only
> based on idle time ratio.  It needs to know current utilisation (used
> cycles) relative to maximum capacity so that the frequency can be
> changed to next higher level.
> 
> Higher level management software that wants to control CPU capacity
> externally will need similar information.
>
I entirely understand that desire.
But you're not giving it that information!
The patch is giving it a really poor approximation, an approximation
that will get worse and worse in upcoming cpu generations.
