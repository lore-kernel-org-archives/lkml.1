Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbYLCVIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbYLCVIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 16:08:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbYLCVIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 16:08:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751138AbYLCVIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 16:08:44 -0500
Date: Wed, 3 Dec 2008 13:07:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       peterz@infradead.org, arjan@infradead.org, dave@linux.vnet.ibm.com,
       containers@lists.osdl.org, ebiederm@xmission.com,
       sukadev@linux.vnet.ibm.com, serue@us.ibm.com, srostedt@redhat.com
Subject: Re: [PATCH 1/3] ftrace: graph of a single function
Message-Id: <20081203130741.473c1262.akpm@linux-foundation.org>
In-Reply-To: <20081203203828.920111079@goodmis.org>
References: <20081203203656.776893226@goodmis.org>
	<20081203203828.920111079@goodmis.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Dec 2008 15:36:57 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> +static int g_show(struct seq_file *m, void *v)
> +{
> +	unsigned long *ptr = v;
> +	char str[KSYM_SYMBOL_LEN];
> +
> +	if (!ptr)
> +		return 0;
> +
> +	kallsyms_lookup(*ptr, NULL, NULL, NULL, str);
> +
> +	seq_printf(m, "%s\n", str);

Can we use %pF here?

> +	return 0;
> +}
