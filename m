Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbYKQSTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbYKQSTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 13:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYKQSTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 13:19:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:38489 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbYKQSTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 13:19:14 -0500
Message-ID: <4921B55F.9030300@kernel.org>
Date: Mon, 17 Nov 2008 10:18:07 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix wakeup_cpu with numaq/es7000 v2
References: <491FDE2A.1010809@kernel.org> <49200031.2040701@kernel.org> <20081117165224.GH12081@elte.hu> <20081117173728.GA7384@elte.hu> <20081117173800.GA7686@elte.hu>
In-Reply-To: <20081117173800.GA7686@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> Config attached. [...]
> 
> attached now for real.
> 
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.28-rc5
# Mon Nov 17 18:10:54 2008
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y

it is 64bit, so something wrong with

+static int __devinit
+wakeup_secondary_cpu(int apicid, unsigned long start_eip)
+{
+	if (x86_quirks->wakeup_secondary_cpu)
+		return x86_quirks->wakeup_secondary_cpu(apicid, start_eip);
+
+	return wakeup_secondary_cpu_via_init(apicid, start_eip);
+}

x86_quirks->wakeup_secondary_cpu get assigned when es7000 with CLUSTERED (_MIP) or numaq  with _nmi

it's werid.

timing issue?

YH
