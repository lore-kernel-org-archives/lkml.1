Return-Path: <linux-kernel-owner+w=401wt.eu-S1753730AbYJaJkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbYJaJkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 05:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbYJaJjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 05:39:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38332 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbYJaJjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 05:39:52 -0400
Date: Fri, 31 Oct 2008 10:39:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>
Subject: Re: [patch] generic-ipi: fix the smp_mb() placement
Message-ID: <20081031093924.GG30317@elte.hu>
References: <20081029224229.GK30573@linux-os.sc.intel.com> <20081030185322.GE17822@elte.hu> <20081030202322.GM30573@linux-os.sc.intel.com> <490A9337.6090504@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490A9337.6090504@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Suresh Siddha wrote:
>> We didn't see the lockup in our tests but Xen folks reported similar failures
>> with their smp call function code.
>>   
>
> ...really?  I don't remember anything like that, but perhaps I'm 
> forgetting something.  In Xen the IPI is sent with a hypercall, 
> which is definitely a solid enough barrier for these purposes.

i think Suresh might be referring to some of the fragilities Xen had 
with generic-ipi. But those AFAICT were due to the on-stack lifetime 
bug that Nick fixed via the kmalloc? v2.6.26-ish issue.

	Ingo
