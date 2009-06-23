Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbZFWHTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbZFWHTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbZFWHTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:19:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44769 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbZFWHTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:19:45 -0400
Date: Tue, 23 Jun 2009 09:19:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, hidave.darkstar@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: +
	printk-add-printk_delay-to-make-messages-readable-for-some-scenarios
	.patch added to -mm tree
Message-ID: <20090623071944.GB5747@elte.hu>
References: <200906230552.n5N5q3al012876@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906230552.n5N5q3al012876@imap1.linux-foundation.org>
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


two minor comments:

> +++ a/kernel/printk.c
> @@ -640,6 +640,19 @@ static int recursion_bug;
>  static int new_text_line = 1;
>  static char printk_buf[1024];
>  
> +int printk_delay_msec;

should be __read_mostly.

> +
> +static inline void printk_delay(void)
> +{
> +	if (unlikely(printk_delay_msec)) {
> +		int m = printk_delay_msec;
> +		while (m--) {

newline needed after local variable.

	Ingo
