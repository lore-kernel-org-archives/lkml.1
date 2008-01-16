Return-Path: <linux-kernel-owner+w=401wt.eu-S1754241AbYAPQG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbYAPQG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 11:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYAPQGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 11:06:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36214 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbYAPQGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 11:06:18 -0500
Date: Wed, 16 Jan 2008 17:06:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@suse.de>, Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0 of 4] x86: some more patches
Message-ID: <20080116160606.GA8650@elte.hu>
References: <patchbomb.1200435425@localhost> <200801161544.15884.ak@suse.de> <20080116145427.GA640@elte.hu> <200801161626.01711.ak@suse.de> <478E3411.76E4.0078.0@novell.com> <20080116154710.GA28946@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080116154710.GA28946@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> -#define PAGE_MASK	(~(PAGE_SIZE-1))
> +#define PAGE_MASK	(_AT(phys_addr_t, ~(PAGE_SIZE-1)))

that should be:

 #define PAGE_MASK      (_AT(phys_addr_t, PAGE_SIZE)-1)

but still - PAGE_MASK is used in a lot of places so i'm nervous about 
this change.

	Ingo
