Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbYIHOKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbYIHOKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 10:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750835AbYIHOJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 10:09:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60193 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbYIHOJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 10:09:58 -0400
Date: Mon, 8 Sep 2008 16:09:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sheng Yang <sheng.yang@intel.com>
Cc: Avi Kivity <avi@qumranet.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 0/2] x86: Add "virt flags"
Message-ID: <20080908140939.GH11993@elte.hu>
References: <12208705553277-git-send-email-sheng.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12208705553277-git-send-email-sheng.yang@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sheng Yang <sheng.yang@intel.com> wrote:

> Hi, Ingo
> 
> (sorry for former noises, I mistake the address... Report to lkml) 
> I've sent this patchset before, but got no comments from upstream at 
> that time.  So I'd like to resend this.
> 
> The virt flags is used for the important hardware virtualization 
> features, like EPT of incoming Nehalem. Because the feature 
> availability are read from MSRs, and I think virtualization features 
> should not at the same level as "vmx", so I added a new flags catagory 
> here.
> 
> But I still have concern, for this may broke some not that reliable 
> userspace programs. So Avi suggested that we can add more fields to 
> flags rather than a new catagory.  What's your opinion? We indeed need 
> a generic user visible way to tell the HW virtualization features.

hm, i think extending the already existing flags category sounds like a 
better solution than the separate virtual CPU flags line in 
/proc/cpuinfo. We already have self-invented flag entries (such as 
X86_FEATURE_NOPL), and adding more for virtualization would be quite 
natural to do, as long as it's reasonably close to the meaning of a 'CPU 
feature'.

Peter, what would be your preference?

	Ingo
