Return-Path: <linux-kernel-owner+w=401wt.eu-S937250AbYEBXUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937250AbYEBXUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 19:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932672AbYEBXUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 19:20:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:36949 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932636AbYEBXUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 19:20:02 -0400
Subject: Re: [POWERPC][v2] Bolt in SLB entry for kernel stack on secondary
	cpus
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Paul Mackerras <paulus@samba.org>
Cc: David Gibson <david@gibson.dropbear.id.au>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <18458.55542.977597.204532@cargo.ozlabs.ibm.com>
References: <18458.39064.783013.268948@cargo.ozlabs.ibm.com>
	 <20080502055648.GA28378@yookeroo.seuss>
	 <18458.55542.977597.204532@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Sat, 03 May 2008 09:19:43 +1000
Message-Id: <1209770383.26383.5.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-02 at 19:03 +1000, Paul Mackerras wrote:
> David Gibson writes:
> 
> > Do you even need the processor ID test at all?  The boot processor
> > should always have its stack covered by SLB entry 0 when we come
> > through here, shouldn't it?
> 
> I was concerned that get_paca()->kstack wouldn't have been initialized
> by the time the boot cpu calls slb_initialize().  If that fear is
> unfounded then the check could go.

No, you are correct, it's not initialized. However, I find that a bit
weird, as we shouldn't have a problem initializing it in
start_here_multiplatform rather than start_here_common.

The whole stack setup part of these here seems like a dup to me.

Ben.


