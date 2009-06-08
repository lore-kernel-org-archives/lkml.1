Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbZFHVuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbZFHVuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 17:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZFHVu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 17:50:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44397 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbZFHVu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 17:50:28 -0400
Date: Mon, 8 Jun 2009 23:50:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf_counter: extensible perf_counter_attr
Message-ID: <20090608215002.GB22049@elte.hu>
References: <1244481941.13761.9119.camel@twins> <4A2D6041.4050309@linux.vnet.ibm.com> <1244490680.6691.1.camel@laptop> <4A2D8011.9050502@linux.vnet.ibm.com> <1244496223.6691.2.camel@laptop> <4A2D82CE.9000206@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2D82CE.9000206@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Corey Ashford <cjashfor@linux.vnet.ibm.com> wrote:

> Peter Zijlstra wrote:
>> On Mon, 2009-06-08 at 14:18 -0700, Corey Ashford wrote:
>>> pca.ext_attrs = &feature.head; /* secretly know that there's data 
>>> that lies past the attr struct header */
>>
>> Right, except its not so very secret since we have the type field
>> telling us.
>
> I see.  Thanks for the explanation.  Looks like a good plan to me!

i think we'd have a much simpler implementation by changing 
__reserved_1 to attr_size. When the kernel adds new attributes, the 
size will increase - old user-space will use the old size which the 
kernel detects and adopts to (by zeroing out that attribute space).

That way we'll always have a nice flat attributes structure, with no 
quirky chaining that has field-dependent data types ...

	Ingo
