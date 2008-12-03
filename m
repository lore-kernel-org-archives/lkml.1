Return-Path: <linux-kernel-owner+w=401wt.eu-S1756304AbYLCVLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304AbYLCVLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 16:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755699AbYLCVKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 16:10:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33956 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580AbYLCVKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 16:10:40 -0500
Date: Wed, 3 Dec 2008 16:10:38 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       peterz@infradead.org, arjan@infradead.org, dave@linux.vnet.ibm.com,
       containers@lists.osdl.org, ebiederm@xmission.com,
       sukadev@linux.vnet.ibm.com, serue@us.ibm.com, srostedt@redhat.com
Subject: Re: [PATCH 1/3] ftrace: graph of a single function
In-Reply-To: <20081203130741.473c1262.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0812031608560.29045@gandalf.stny.rr.com>
References: <20081203203656.776893226@goodmis.org> <20081203203828.920111079@goodmis.org> <20081203130741.473c1262.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Dec 2008, Andrew Morton wrote:

> On Wed, 03 Dec 2008 15:36:57 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > +static int g_show(struct seq_file *m, void *v)
> > +{
> > +	unsigned long *ptr = v;
> > +	char str[KSYM_SYMBOL_LEN];
> > +
> > +	if (!ptr)
> > +		return 0;
> > +
> > +	kallsyms_lookup(*ptr, NULL, NULL, NULL, str);
> > +
> > +	seq_printf(m, "%s\n", str);
> 
> Can we use %pF here?

If there's a way to not print the "+offset".

blk_unplug looks much nicer than blk_unplug+0x78/0x278

-- Steve

