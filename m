Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbYLCVdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbYLCVdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 16:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbYLCVdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 16:33:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751886AbYLCVdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 16:33:38 -0500
Date: Wed, 3 Dec 2008 13:32:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       peterz@infradead.org, arjan@infradead.org, dave@linux.vnet.ibm.com,
       containers@lists.osdl.org, ebiederm@xmission.com,
       sukadev@linux.vnet.ibm.com, serue@us.ibm.com, srostedt@redhat.com
Subject: Re: [PATCH 1/3] ftrace: graph of a single function
Message-Id: <20081203133242.4e80bbe6.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0812031608560.29045@gandalf.stny.rr.com>
References: <20081203203656.776893226@goodmis.org>
	<20081203203828.920111079@goodmis.org>
	<20081203130741.473c1262.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0812031608560.29045@gandalf.stny.rr.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2008 16:10:38 -0500 (EST)
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> 
> On Wed, 3 Dec 2008, Andrew Morton wrote:
> 
> > On Wed, 03 Dec 2008 15:36:57 -0500
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > +static int g_show(struct seq_file *m, void *v)
> > > +{
> > > +	unsigned long *ptr = v;
> > > +	char str[KSYM_SYMBOL_LEN];
> > > +
> > > +	if (!ptr)
> > > +		return 0;
> > > +
> > > +	kallsyms_lookup(*ptr, NULL, NULL, NULL, str);
> > > +
> > > +	seq_printf(m, "%s\n", str);
> > 
> > Can we use %pF here?
> 
> If there's a way to not print the "+offset".

Could be added, I guess.  I wonder if it would be
reused elsewhere.

> blk_unplug looks much nicer than blk_unplug+0x78/0x278

<mutters something about in-kernel pretty-printers>
