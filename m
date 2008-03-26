Return-Path: <linux-kernel-owner+w=401wt.eu-S1760684AbYCZU3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684AbYCZU3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 16:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757174AbYCZU3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 16:29:37 -0400
Received: from www.tglx.de ([62.245.132.106]:44069 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756061AbYCZU3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 16:29:36 -0400
Date: Wed, 26 Mar 2008 21:29:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Lameter <clameter@sgi.com>
cc: "Luck, Tony" <tony.luck@intel.com>, linux-arch@vger.kernel.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: What if a TLB flush needed to sleep?
In-Reply-To: <Pine.LNX.4.64.0803261222090.31000@schroedinger.engr.sgi.com>
Message-ID: <alpine.LFD.1.00.0803262121440.3781@apollo.tec.linutronix.de>
References: <1FE6DD409037234FAB833C420AA843ECE9DF60@orsmsx424.amr.corp.intel.com> <Pine.LNX.4.64.0803261222090.31000@schroedinger.engr.sgi.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008, Christoph Lameter wrote:

> On Tue, 25 Mar 2008, Luck, Tony wrote:
> 
> > 2) Is it feasible to rearrange the MM code so that we don't
> > hold any locks while doing a TLB flush?  Or should I implement
> > some sort of spin_only_semaphore?
> 
> The EMM notifier V2 patchset contains two patches that 
> convert the immap_lock and the anon_vma lock to semaphores.

Please use a mutex, not a semaphore. semaphores should only be used
when you need a counting sempahore.

Thanks,

	tglx
