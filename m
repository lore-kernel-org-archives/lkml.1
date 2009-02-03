Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbZBCMYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbZBCMYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 07:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbZBCMX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 07:23:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36507 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151AbZBCMX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 07:23:57 -0500
Date: Tue, 3 Feb 2009 13:23:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mandeep Singh Baines <msb@google.com>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, rientjes@google.com, mbligh@google.com,
       thockin@google.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2 v2] softlockup: check all tasks in hung_task
Message-ID: <20090203122346.GE19979@elte.hu>
References: <1233429757.4787.40.camel@laptop> <20090203000505.GA10316@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203000505.GA10316@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Mandeep Singh Baines <msb@google.com> wrote:

> +		if (sysctl_hung_task_check_count && !(max_count--)) {
> +			max_count = sysctl_hung_task_check_count;

just a minor nit, why not:

	!--max_count

?

That way we can lose the parenthesis and we'll also not overcount and wont 
let max_count go down to -1.

	Ingo
