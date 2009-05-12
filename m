Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbZELVFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbZELVFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 17:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbZELVFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 17:05:36 -0400
Received: from www.tglx.de ([62.245.132.106]:38066 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbZELVFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 17:05:35 -0400
Date: Tue, 12 May 2009 23:04:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       Robert Richter <robert.richter@amd.com>, Dave Jones <davej@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 3/10 -tip] x86: Add cpufeatures for Advanced Power
 Management
In-Reply-To: <1242155190.2492.73.camel@ht.satnam>
Message-ID: <alpine.LFD.2.00.0905122219420.3561@localhost.localdomain>
References: <1242142530.2547.11.camel@ht.satnam>  <1242142623.2547.13.camel@ht.satnam>  <1242142692.2547.15.camel@ht.satnam>  <1242142753.2547.16.camel@ht.satnam> <1242155190.2492.73.camel@ht.satnam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder,

On Wed, 13 May 2009, Jaswinder Singh Rajput wrote:
> +	/* Advanced Power Management (Function 8000_0007h), edx */
> +	if (c->extended_cpuid_level >= 0x80000007) {
> +		c->x86_capability[9] = cpuid_edx(0x80000007);

In the reply to [Patch 5/10] Ingo wrote:
>> Also, open-coding x86_capability[9] like that is quite unclean. Were 
>> we ever to reorder those bits internally, this could would break.

Do you really believe that open-coding x86_capability[9] in .../common.c
is better than the open-coding in ../powernow-k8.c ?

Again, open-coding is wrong and error prone. Ingo explicitely asked for a
helper function. All you did is moving the open-coded hard wired array
reference to a different place.

Please start to listen to the review comments as long as people are
willing to look at your patches. Seriously, the noise/useful ratio of
your patches is annoying and adds an unjustified burden to the
maintainers of that code.

Thanks,

	tglx
