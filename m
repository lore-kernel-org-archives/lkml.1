Return-Path: <linux-kernel-owner+w=401wt.eu-S1031188AbXDSHcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031188AbXDSHcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 03:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031161AbXDSHcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 03:32:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60225 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989AbXDSHcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 03:32:25 -0400
Date: Thu, 19 Apr 2007 09:32:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] workqueue: debug possible endless loop in cancel_rearming_delayed_work
Message-ID: <20070419073222.GA438@elte.hu>
References: <20070419065404.GB1782@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419065404.GB1782@ff.dom.local>
User-Agent: Mutt/1.4.2.2i
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


* Jarek Poplawski <jarkao2@o2.pl> wrote:

> +		int i = 1000;
>  
> -		while (!cancel_delayed_work(dwork))
> +		while (!cancel_delayed_work(dwork)) {
>  			flush_workqueue(wq);
> +			BUG_ON(!i--);
> +		}

if then make it a WARN_ON(). But ... dont we have the softlockup 
detector for such cases? Does CONFIG_DETECT_SOFTLOCKUP=y give you enough 
information?

	Ingo
