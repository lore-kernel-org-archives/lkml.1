Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbYAIKUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbYAIKUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 05:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbYAIKUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 05:20:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34520 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbYAIKUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 05:20:33 -0500
Date: Wed, 9 Jan 2008 11:20:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Change x86 Machine check handler to use unlocked_iocl
	instead of ioctl
Message-ID: <20080109102017.GA8041@elte.hu>
References: <4785B342.2070501@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4785B342.2070501@suse.de>
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


* Nikanth Karthikesan <knikanth@suse.de> wrote:

> The Machine check handler registers ioctl handler that is called with 
> the BKL held. Changing to register unlocked_ioctl instead. Also mce 
> ioctl handler does not seem to need any lock protection.
> 
> Change the Machine check handler to use unlocked_ioctl instead of 
> ioctl handler. Also the mce ioctl handler does not need any lock 
> protection.

thanks, applied to x86.git. Mcelog functionality uses cmpxchg so no need 
for the BKL there. The ioctl still being BKL is purely historic and it 
was never relied on.

	Ingo
