Return-Path: <linux-kernel-owner+w=401wt.eu-S932568AbXLNEvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568AbXLNEvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 23:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760074AbXLNEvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 23:51:37 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48554 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbXLNEvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 23:51:36 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Roland Dreier <rdreier@cisco.com>
Cc: venkatesh.pallipadi@intel.com, ak@muc.de, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, akpm@linux-foundation.org,
       arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 06/12] PAT 64b: Add ioremap_wc support
References: <20071213235543.568682000@intel.com>
	<20071213235712.339088000@intel.com> <ada8x3x7vw5.fsf@cisco.com>
	<m1sl25q4rc.fsf@ebiederm.dsl.xmission.com> <ada4pel7v6a.fsf@cisco.com>
Date: Thu, 13 Dec 2007 21:48:36 -0700
In-Reply-To: <ada4pel7v6a.fsf@cisco.com> (Roland Dreier's message of "Thu, 13
	Dec 2007 20:32:45 -0800")
Message-ID: <m1odctq3tn.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <rdreier@cisco.com> writes:

>  > > Also I didn't see anything like pgprot_wc() in the patchset (although
>
>  > pgprot_writcombined.
>
> Oh I see it now (pgprot_writecombine() actually).
>
> However the same comment as before applies: there needs to be a
> fallback to pgprot_noncached() for all other architectures so that
> drivers can actually use it in a sane way.

Sounds reasonable.

There are three distinct pieces to this.
- Getting arch/x86 caught up the state art in linux
- Getting the state of the art generalized so everyone can use it.
- Figuring how to generally do the proper conflict checking so we
  don't shoot ourselves in the head by accident.

They are all independent problems and can be solved in any order.

It should be the conflict checking that is the actual bottleneck.
The rest is just gravy.

Eric
