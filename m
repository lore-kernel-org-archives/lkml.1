Return-Path: <linux-kernel-owner+w=401wt.eu-S1762932AbYCFKlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762932AbYCFKlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 05:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756191AbYCFKlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 05:41:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47833 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756601AbYCFKle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 05:41:34 -0500
Date: Thu, 6 Mar 2008 11:41:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: make task_nice available to non-GPL modules
Message-ID: <20080306104119.GF13391@elte.hu>
References: <20080305215637.7767.99635.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305215637.7767.99635.stgit@dv.roinet.com>
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


* Pavel Roskin <proski@gnu.org> wrote:

> The API is trivial, and so is the implementation.  Linux priorities 
> are exposed to the userspace, so nobody should claim that software 
> aware of Linux priorities is a derived work of the kernel.
> 
> The complementary function set_user_nice() is available to non-GPL 
> modules.  If the module can set the priority, it should be able to 
> read it back.

i've applied this, but i removed the (incorrect) legal interpretation in
the commit message. We simply make it available generally, and the
export is not restricted to clearly internal modules only. (but that
does not mean that a module using it is not a derived work)

this is a fine but important distinction. If a module uses a GPL symbol, 
it is a strong hint of being derived work. But by not using GPL-only 
symbols (but using other symbols - or not using kernel symbols at all) 
it might still be derived work and even if it's not derived work, it 
might still fall under the GPL.

in other words: EXPORT_SYMBOL does not mean and never meant 
EXPORT_SYMBOL_NON_GPL.

EXPORT_SYMBOL_GPL is EXPORT_SYMBOL_I_ADMIT_MY_MODULE_IS_DERIVED, and 
EXPORT_SYMBOL is EXPORT_SYMBOL_ASK_YOUR_LAWYER.

	Ingo
