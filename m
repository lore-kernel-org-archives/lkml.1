Return-Path: <linux-kernel-owner+w=401wt.eu-S1756599AbYCZGSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbYCZGSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 02:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbYCZGSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 02:18:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39845 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbYCZGSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 02:18:38 -0400
Date: Wed, 26 Mar 2008 07:18:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/12] cpumask: reduce stack pressure from local/passed
	cpumask variables v2
Message-ID: <20080326061824.GB18301@elte.hu>
References: <20080326013811.569646000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326013811.569646000@polaris-admin.engr.sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Modify usage of cpumask_t variables to use pointers as much as 
> possible.

hm, why is there no minimal patch against -git that does nothing but 
introduces the new pointer based generic APIs (without using them) - 
such as set_cpus_allowed_ptr(), etc.? Once that is upstream all the 
remaining changes can trickle one arch and one subsystem at a time, and 
once that's done, the old set_cpus_allowed() can be removed. This is far 
more manageable than one large patch.

and the cpumask_of_cpu() change should be Kconfig based initially - once 
all arches have moved to it (or even sooner) we can remove that.

	Ingo
