Return-Path: <linux-kernel-owner+w=401wt.eu-S1763152AbZDBGnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763152AbZDBGnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 02:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756215AbZDBGnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 02:43:00 -0400
Received: from viefep17-int.chello.at ([62.179.121.37]:19517 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbZDBGm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 02:42:59 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 13/15] perf_counter: provide generic callchain bits
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <49D3F7E4.7010308@linux.vnet.ibm.com>
References: <20090330170701.856843742@chello.nl>
	 <20090330171024.254266860@chello.nl>
	 <18897.46177.528910.51044@cargo.ozlabs.ibm.com>
	 <1238481552.28248.1384.camel@twins> <49D1C544.7020403@linux.vnet.ibm.com>
	 <18897.56973.324304.995540@cargo.ozlabs.ibm.com>
	 <1238508032.8530.278.camel@twins>
	 <18898.58399.957182.181124@drongo.ozlabs.ibm.com>
	 <1238572744.8530.2541.camel@twins>  <49D3F7E4.7010308@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 08:43:51 +0200
Message-Id: <1238654631.8530.5361.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-01 at 16:25 -0700, Corey Ashford wrote:

> > struct callchain_event {
> > 	u64 nr
> > 	u64 ips[nr]
> > };
> 
> Looking at the current version of perf_counter.h in the -tip tree, this 
> struct definition is not visible to userspace (it's in the #ifdef KERNEL 
> section).

Correct. Its been on my todo list to write a meta-struct definition
along with the perf_event_type enum that details the data layout of the
various types, but not include any actual structure other than the
header in the userspace bits.

Also, related to a comment Paul made on callchain markers, I wanted to
change it so that we have ip markers in the chain that separate the
kernel and user bits.

I was thinking of ending the kernel trace with -1ULL and ending the user
chain with 0ULL. Presumably we need one more to end hypervisor chains in
case anybody manages to generate those ;-).

This chain however will not change the struct, it will merely add 2
extra entries.

