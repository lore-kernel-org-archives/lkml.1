Return-Path: <linux-kernel-owner+w=401wt.eu-S1758688AbZHRP6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688AbZHRP6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 11:58:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbZHRP6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 11:58:03 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58330 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbZHRP6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 11:58:01 -0400
Date: Wed, 19 Aug 2009 00:57:46 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Subject: Re: [RFC PATCH] Add timer-source of walltime for ftrace
Cc: kosaki.motohiro@jp.fujitsu.com, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A89213C.5090109@cn.fujitsu.com>
References: <alpine.DEB.2.00.0907272218480.30108@gandalf.stny.rr.com> <4A89213C.5090109@cn.fujitsu.com>
Message-Id: <20090818215620.A63C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +u64 notrace trace_clock_walltime(void)
> +{
> +	u32 remainder;
> +	return base_walltime.tv_sec + div_u64_rem(
> +			trace_clock() + base_walltime.tv_nsec,
> +			NSEC_PER_SEC, &remainder);
> +}

Why do we need calculate walltime at ring-buffer recordng phase?
IOW, Why can't we calculate this at displaing time?




