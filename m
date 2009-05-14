Return-Path: <linux-kernel-owner+w=401wt.eu-S1762153AbZENGvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762153AbZENGvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 02:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbZENGve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 02:51:34 -0400
Received: from viefep13-int.chello.at ([62.179.121.33]:59302 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbZENGve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 02:51:34 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 3/3] perf_counter: powerpc: supply more precise
 information on counter overflow events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <18955.37028.48861.555309@drongo.ozlabs.ibm.com>
References: <18955.37028.48861.555309@drongo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Thu, 14 May 2009 08:51:32 +0200
Message-Id: <1242283892.26820.43.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-14 at 13:31 +1000, Paul Mackerras wrote:
> This uses values from the MMCRA, SIAR and SDAR registers on powerpc to
> supply more precise information for overflow events, including a data
> address when PERF_RECORD_ADDR is specified.
> 
> Since POWER6 uses different bit positions in MMCRA from earlier processors,
> this converts the struct power_pmu limited_pmc5_6 field, which only had
> 0/1 values, into a flags field and defines bit values for its previous
> use (PPMU_LIMITED_PMC5_6) and a new flag (PPMU_ALT_SIPR) to indicate
> that the processor uses the POWER6 bit positions rather than the earlier
> positions.  It also adds definitions in reg.h for the new and old positions
> of the bit that indicates that the SIAR and SDAR values come from the
> same instruction.
> 
> For the data address, the SDAR value is supplied if we are not doing
> instruction sampling.  In that case there is no guarantee that the address
> given in the PERF_RECORD_ADDR subrecord will correspond to the instruction
> whose address is given in the PERF_RECORD_IP subrecord.
> 
> If instruction sampling is enabled (e.g. because this counter is counting
> a marked instruction event), then we only supply the SDAR value for the
> PERF_RECORD_ADDR subrecord if it corresponds to the instruction whose
> address is in the PERF_RECORD_IP subrecord.  Otherwise we supply 0.

Very cool hardware feature! :-)

