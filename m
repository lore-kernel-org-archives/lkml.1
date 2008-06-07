Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbYFGAl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbYFGAl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 20:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbYFGAlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 20:41:16 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35328 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbYFGAlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 20:41:15 -0400
Subject: Re: [PATCH -mm 2/2] kprobes: add tests for register_kprobes
From: Jim Keniston <jkenisto@us.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       David Miller <davem@davemloft.net>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <484944CA.902@redhat.com>
References: <484944CA.902@redhat.com>
Content-Type: text/plain
Date: Fri, 06 Jun 2008 17:36:26 -0700
Message-Id: <1212798986.4088.23.camel@dyn9047018139.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-06 at 10:08 -0400, Masami Hiramatsu wrote:
> Add testcases for *probe batch registration (register_kprobes)
> to kprobes sanity tests.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> CC: Jim Keniston <jkenisto@us.ibm.com>
> CC: David Miller <davem@davemloft.net>
> ---
>  ...
> +
> +static int test_kprobes(void)
> +{
> +	int ret;
> +	struct kprobe *kps[2] = {&kp, &kp2};

preh_val and posth_val are being reused after test_kprobe(), which sets
them to non-zero values.  Seems like you want to reinitialize them here
as well as below.

Ditto jph_val for jprobes and krph_val for kretprobes.

Ack otherwise.
Jim

+
> +	ret = register_kprobes(kps, 2);
> +	if (ret < 0) {
> +		printk(KERN_ERR "Kprobe smoke test failed: "
> +				"register_kprobes returned %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = target(rand1);
> +
> +	if (preh_val == 0) {
> +		printk(KERN_ERR "Kprobe smoke test failed: "
> +				"kprobe pre_handler not called\n");
> +		handler_errors++;
> +	}
> +
> +	if (posth_val == 0) {
> +		printk(KERN_ERR "Kprobe smoke test failed: "
> +				"kprobe post_handler not called\n");
> +		handler_errors++;
> +	}
> +
> +	preh_val = 0;
> +	posth_val = 0;
> +	ret = target2(rand1);
> ...

