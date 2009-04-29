Return-Path: <linux-kernel-owner+w=401wt.eu-S1760064AbZD2LQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064AbZD2LQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbZD2LQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:16:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35937 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbZD2LQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:16:37 -0400
Subject: Re: [PATCH 04/29] x86/perfcounters: rework
 pmc_amd_save_disable_all() and pmc_amd_restore_all()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robert Richter <robert.richter@amd.com>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090429111159.GJ2373@elte.hu>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
	 <1241002046-8832-5-git-send-email-robert.richter@amd.com>
	 <1241003260.8021.236.camel@laptop>  <20090429111159.GJ2373@elte.hu>
Content-Type: text/plain
Date: Wed, 29 Apr 2009 13:16:25 +0200
Message-Id: <1241003785.8021.248.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-29 at 13:11 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Wed, 2009-04-29 at 12:47 +0200, Robert Richter wrote:
> > > MSR reads and writes are expensive. This patch adds checks to avoid
> > > its usage where possible.
> > 
> > save_disable_all()
> > enable(1)
> > restore_all()
> > 
> > would not correctly enable 1 with the below modification as we do 
> > not write the configuration into the msr, on which restore relies, 
> > as it only toggles the _ENABLE bit.
> > 
> > That said, I'm not sure if that's really an issue, but its why the 
> > does does as it does.
> > 
> > A better abstraction could perhaps avoid this issue all-together.
> 
> Could we remove the disable-all facility altogether and make the 
> core code NMI-safe? The current approach wont scale on CPUs that 
> dont have global-disable features.
> 
> disable-all was arguably a hack i introduced and which spread too 
> far. Can you see a conceptual need for it?

power suffers the same issue and simply iterates the things like amd
does now.

The thing is, with a global disable you get slightly better coupling, so
in that respect it might be nice to have.

