Return-Path: <linux-kernel-owner+w=401wt.eu-S1762090AbYDYMRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762090AbYDYMRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 08:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbYDYMRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 08:17:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55340 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbYDYMRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 08:17:38 -0400
Subject: Re: [PATCH] sched: add statics, don't return void expressions
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1209086275.20088.4.camel@brick>
References: <1209086275.20088.4.camel@brick>
Content-Type: text/plain
Date: Fri, 25 Apr 2008 14:17:06 +0200
Message-Id: <1209125826.24931.12.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-24 at 18:17 -0700, Harvey Harrison wrote:
> Noticed by sparse:
> kernel/sched.c:760:20: warning: symbol 'sched_feat_names' was not declared. Should it be static?
> kernel/sched.c:767:5: warning: symbol 'sched_feat_open' was not declared. Should it be static?
> kernel/sched_fair.c:845:3: warning: returning void-valued expression
> kernel/sched.c:4386:3: warning: returning void-valued expression

I'm still of two minds about that latter warning, I think:

void foo(void);

void bar(void)
{
	return foo();
}

isn't wrong, as the return types match.


