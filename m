Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbYKQVJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbYKQVJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbYKQVG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:06:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:58272 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755157AbYKQVG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:06:28 -0500
Message-ID: <4921DCB8.3050008@kernel.org>
Date: Mon, 17 Nov 2008 13:06:00 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix wakeup_cpu with numaq/es7000 v2
References: <491FDE2A.1010809@kernel.org> <49200031.2040701@kernel.org> <20081117165224.GH12081@elte.hu> <20081117173728.GA7384@elte.hu>
In-Reply-To: <20081117173728.GA7384@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> hm, one of my testboxes is rather unhappy about your patch:


found the problem...

static struct x86_quirks default_x86_quirks __initdata;

struct x86_quirks *x86_quirks __initdata = &default_x86_quirks;


we can not use that x86_quirks anymore because it is __init...

need to move the func to genapic

YH
