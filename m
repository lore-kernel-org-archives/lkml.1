Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbXFUMRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbXFUMRE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 08:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754531AbXFUMQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 08:16:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58200 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041AbXFUMQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 08:16:54 -0400
Date: Thu, 21 Jun 2007 14:16:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: pj@sgi.com, clameter@sgi.com, linux-kernel@vger.kernel.org,
       Dinakar Guniguntala <dino@in.ibm.com>, akpm@linux-foundation.org
Subject: Re: cpuset attach_task to touch per-cpu kernel threads?
Message-ID: <20070621121635.GB19811@elte.hu>
References: <20070621014935.GF10980@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070621014935.GF10980@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> But I am wondering if attach_task() should leave kernel threads alone 
> and act only upon user-space threads. Or maybe allow movement if it 
> doesn't result in changing kernel-threads's cpu affinity.

yeah, i'd agree with the latter. We could also special-case the 
migration thread to never be migrated itself. (although that's not the 
end of the matter either - two ksoftirqds on a cpu are not healty)

	Ingo
