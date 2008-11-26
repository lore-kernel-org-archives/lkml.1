Return-Path: <linux-kernel-owner+w=401wt.eu-S1753656AbYKZIg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbYKZIg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750916AbYKZIgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:36:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797AbYKZIgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:36:50 -0500
Date: Wed, 26 Nov 2008 00:35:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/5] ftrace: use code patching for ftrace graph tracer
Message-Id: <20081126003553.12d38150.akpm@linux-foundation.org>
In-Reply-To: <1227688024.5511.56.camel@brick>
References: <20081126051622.134970943@goodmis.org>
	<20081126051709.774546196@goodmis.org>
	<20081125213546.ff4eddf4.akpm@linux-foundation.org>
	<1227682349.5511.47.camel@brick>
	<20081126000430.5c19e189.akpm@linux-foundation.org>
	<1227688024.5511.56.camel@brick>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008 00:27:04 -0800 Harvey Harrison <harvey.harrison@gmail.com> wrote:

> if (code[0] != 0xe9 || old_offset != load32_noalign(&code[1]))
> 
> This is similar to the new API in -mm load_le32_noalign, but I
> don't think it would be worth load_u32_noalign...load32 should
> be enough.
> 
> > > > > +		return -EINVAL;
> > > > > +
> > > > > +	*(int *)(&code[1]) = new_offset;
> > > > 
> > > > Might be able to use put_unaligned_foo() here.
> > > > 
> > > 
> > > 	put_unaligned(new_offset, (int *)(&code[1]));
> > > 
> 
> In a similar vein to above, this becomes:
> 
> 	store32_noalign(&code[1], new_offset);
> 

yes, that's much better than the party tricks with magical sizeof,
which forces you to run around and check the types of everything.

I've seen people doing get_user() on `long' types and such things
occasionally.

