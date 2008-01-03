Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbYACJZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbYACJZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 04:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbYACJZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 04:25:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32842 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754428AbYACJZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 04:25:18 -0500
Date: Thu, 3 Jan 2008 10:25:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/3] move WARN_ON() out of line
Message-ID: <20080103092502.GA16096@elte.hu>
References: <477C32DA.5060905@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477C32DA.5060905@linux.intel.com>
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


* Arjan van de Ven <arjan@linux.intel.com> wrote:

> +#define WARN_ON(condition) do_warn_on((unsigned long)(condition), __FILE__, \
> +					 __LINE__, __FUNCTION__)

hm. This passes in 4 arguments to do_warn_on().

i think we could get away with no arguments (!), by using section 
tricks. Firstly, we can get rid of __FUNCTION__ and replace it with a 
ksyms lookup - that is fine enough. Secondly, we could put __FILE__ and 
__LINE__ into a text section and key it up to the return address from 
do_warn_on().

the condition code should not be passed in at all i think - it creates 
extra function calls to do_warn_on() all the time.

	Ingo
