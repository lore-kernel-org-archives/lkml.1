Return-Path: <linux-kernel-owner+w=401wt.eu-S1752402AbZEFIZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbZEFIZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 04:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbZEFIZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 04:25:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59429 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbZEFIZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 04:25:01 -0400
Date: Wed, 6 May 2009 10:24:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 10/11] ring-buffer: move big if statement down
Message-ID: <20090506082447.GA28675@elte.hu>
References: <20090506042101.231470089@goodmis.org> <20090506042334.938331281@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506042334.938331281@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> This patch changes it to a goto:
> 
> 	code;
> 
> 	if (cross to next page)
> 		goto next_page;
> 
> 	more code;
> 
> 	return;
> 
> next_page:
> 
> 	[ lots of code]

I have pulled it, but could you please change it to a helper 
function instead? There's almost never a good reason to combine 
'more code' with 'lots of code' in a single function. It also 
documents the unlikeliness, etc.

	Ingo
