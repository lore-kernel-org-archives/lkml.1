Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbZD2L2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbZD2L2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbZD2L15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:27:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43869 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbZD2L15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:27:57 -0400
Subject: Re: [PATCH 04/29] x86/perfcounters: rework
 pmc_amd_save_disable_all() and pmc_amd_restore_all()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robert Richter <robert.richter@amd.com>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090429111934.GA8298@elte.hu>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
	 <1241002046-8832-5-git-send-email-robert.richter@amd.com>
	 <1241003260.8021.236.camel@laptop> <20090429111159.GJ2373@elte.hu>
	 <1241003785.8021.248.camel@laptop>  <20090429111934.GA8298@elte.hu>
Content-Type: text/plain
Date: Wed, 29 Apr 2009 13:27:46 +0200
Message-Id: <1241004466.8021.266.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-29 at 13:19 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > > disable-all was arguably a hack i introduced and which spread too 
> > > far. Can you see a conceptual need for it?
> > 
> > power suffers the same issue and simply iterates the things like 
> > amd does now.
> > 
> > The thing is, with a global disable you get slightly better 
> > coupling, so in that respect it might be nice to have.
> 
> ok. With system-wide profiling there's no global disable/enable in 
> the fastpath. Do we have any of them in the per task counter 
> fastpath?

the scheduling bits seem to be littered with
hw_perf_save_disable/restore, other than that I think the overflow
interrupt used it.

