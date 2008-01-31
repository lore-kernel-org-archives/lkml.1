Return-Path: <linux-kernel-owner+w=401wt.eu-S1763406AbYAaQPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763406AbYAaQPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755066AbYAaQPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:15:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54102 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932AbYAaQPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:15:32 -0500
Date: Thu, 31 Jan 2008 08:15:07 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Pekka Paalanen <pq@iki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, Harvey Harrison <harvey.harrison@gmail.com>,
       linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Pavel Roskin <proski@gnu.org>,
       pq@iki.fi
Subject: Re: [PATCH v2] x86: Add a list for custom page fault handlers.
Message-ID: <20080131081507.5edcde10@laptopd505.fenrus.org>
In-Reply-To: <20080131180253.6c007852@daedalus.pq.iki.fi>
References: <20080127185238.4bcac54b@daedalus.pq.iki.fi>
	<1201660102.8837.9.camel@brick>
	<1201660453.8837.13.camel@brick>
	<20080130200827.322c4f7d@daedalus.pq.iki.fi>
	<20080131150746.GB11996@elte.hu>
	<20080131180253.6c007852@daedalus.pq.iki.fi>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008 18:02:53 +0200
Pekka Paalanen <pq@iki.fi> wrote:

> > could you please send us a patch for the whole mmiotrace
> > kernel-side feature, so that we can have a look at the general
> > structure of this? (and the interaction with change_page_attr(),
> > etc.) Even if it's not functional (and wont even build/boot) at the
> > moment. Thanks,
> 
> Very well, first the revised custom page fault handler patch.
> Changes since the previous submit:
> - use spin_lock_irqsave instead of spin_lock
> - Harvey Harrison's clean-up with the #ifdefs
> - handler call site moved earlier
> - remove sync RCU call
> 
> I'm not aware of any functional problems with this one.
> 
> Arjan, you said you don't like this. May I ask why?

it's overhead that's rarely used, and worse, it suffers from the LSM disease:
it's a hook without visibility into the callers. Esp if there's only 1 user, a direct call
is not only faster, it also shows you what is going on when you're reading the code.
THe page fault stuff is tricky enough as it is without any "call arbitrary thing" hooks into
it

> This is most convinient for mmiotrace as it is meant to be a module.

that's not per se mutually exclusive, there's other cases like this already
(but even then, I don't want to go through hoops to make mmiotracing a module;
for me I can totally see it becoming a full mature member of the kernel, and if
that means a few things have to be changed in the normal kernel, or infrastructure
added, I'm totally ok with that)

> I'm also using this as an excuse to let other people to get into the
> page fault handler with their out-of-tree-today modules.

this is exactly the point.. it becomes a totally opaque thing, a random hook.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
