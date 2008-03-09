Return-Path: <linux-kernel-owner+w=401wt.eu-S1752926AbYCILtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbYCILtR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 07:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbYCILtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 07:49:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48914 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbYCILtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 07:49:04 -0400
Date: Sun, 9 Mar 2008 12:48:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, gvaughan@jpl.nasa.gov, akpm@osdl.org,
       jeremy@goop.org
Subject: Re: [PATCH] Fix check after use in kernel/exit.c
Message-ID: <20080309114844.GC30331@elte.hu>
References: <20080308.161105.253167431.xiyou.wangcong@gmail.com> <20080308083637.GA23555@elte.hu> <20080308085322.GA29628@elte.hu> <20080308.165821.119846418.xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080308.165821.119846418.xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3569]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* WANG Cong <xiyou.wangcong@gmail.com> wrote:

> > actually, i unapplied it again because the patch is wrong: 
> > mm_release() has side-effects for kernel threads such as the 
> > deactivate_mm() [which is important even if the user-mm is NULL]. If 
> > the NULL mm dereference can really trigger then it should be avoided 
> > within mm_release().
> 
> Do you mean that the NULL check should be moved into mm_release()?

yes - we need to run deactivate_mm() for kernel threads.

	Ingo
