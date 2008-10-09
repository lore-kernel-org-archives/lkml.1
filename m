Return-Path: <linux-kernel-owner+w=401wt.eu-S1759868AbYJIOFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759868AbYJIOFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 10:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758114AbYJIOFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 10:05:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47869 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755105AbYJIOFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 10:05:32 -0400
Date: Thu, 9 Oct 2008 16:05:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] markers: fix unchecked format
Message-ID: <20081009140505.GA2021@elte.hu>
References: <48EC19A8.4010307@cn.fujitsu.com> <20081008040508.GB31788@Krystal> <48EC3F50.7050306@cn.fujitsu.com> <20081009134606.GB15553@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081009134606.GB15553@Krystal>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> > 
> > No.
> > 
> > 1)
> > In current code, when the second, third... probe is registered
> > with the same marker name, its format is not checked.
> > 
> > marker_probe_register("marker_name", "field1 %s", XXX);
> > marker_probe_register("marker_name", "field1 %d", XXX);
> > 
> > the second call, "field1 %d" is not check for ever.
> > and this probe may cause kernel core-dump.
> > 
> > because these two probes share the same marker_entry, and
> > we do not check the format when they are being shared.
> > 
> > if several probes share the same marker_entry we should
> > make sure all these probes's format are the same.
> > 
> 
> Yep, you are right. Thanks for the explanation.
> 
> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

applied to tip/tracing/markers, thanks!

	Ingo
