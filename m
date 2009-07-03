Return-Path: <linux-kernel-owner+w=401wt.eu-S1757614AbZGCC0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbZGCC0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 22:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756628AbZGCCZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 22:25:53 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:49107 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbZGCCZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 22:25:52 -0400
Date: Thu, 2 Jul 2009 19:25:53 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Benjamin Blum <bblum@google.com>
Cc: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       lizf@cn.fujitzu.com
Subject: Re: [PATCH 1/2] Adds a read-only "procs" file similar to "tasks"
	that shows only unique tgids
Message-ID: <20090703022553.GJ19135@count0.beaverton.ibm.com>
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com> <20090702232620.3969.16680.stgit@menage.mtv.corp.google.com> <20090702164649.303c4952.akpm@linux-foundation.org> <2f86c2480907021731h13e0bb95q94f06829eded9aa6@mail.gmail.com> <20090702175341.fd2e26d5.akpm@linux-foundation.org> <6599ad830907021808o6f3bb51eh324e4bf13544d83e@mail.gmail.com> <2f86c2480907021817o79fce75yd9785aab682f7bb4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2f86c2480907021817o79fce75yd9785aab682f7bb4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 06:17:56PM -0700, Benjamin Blum wrote:
> On Thu, Jul 2, 2009 at 6:08 PM, Paul Menage<menage@google.com> wrote:
> > On Thu, Jul 2, 2009 at 5:53 PM, Andrew Morton<akpm@linux-foundation.org> wrote:

<snip>

> >
> >>
> >> One could perhaps create an alias (symlink?) and leave that in place
> >> for a few kernel releases and then remove the old names.  The trick to
> >> doing this politely is to arrange for a friendly printk to come out
> >> when userspace uses the old filename, so people know to change their
> >> tools.  That printk should come out once-per-boot, not once-per-access.
> >
> > Personally, I feel that a bit of ugliness in the naming inconsistency
> > is less painful than trying to deprecate something that people might
> > be using.
> 
> That's what the people who designed x86 said :P

And look at how successful x86 has been! ;)

Seriously, I don't think the name "tasks" is ugly. I think "tasks"
is a nice balance between overly verbose ("cgroup.tasks") and specificity.
If anything I think the new file should be called "processes", not
"cgroup.procs". The established convention was "subsys.foo". cgroup is not
a subsystem of itself hence the names "tasks" and "processes" are just fine.

> > If we could just flip the names without breaking anyone,
> > that would be great, but this is just a style issue rather than a
> > functional issue. My experience of such printk() statements scattered
> > around in code is that no-one takes much notice of them.

I agree with Paul.

> 
> Whether or not we get rid of the old ones, it would be good to put in
> aliases with the new style now so there's the option of removing the
> old style ones later.

What a terrible idea! If every alias has an uncertain future nobody will
know which they should use. As a consequence 50% may use "tasks" and 50%
may use "cgroup.tasks" and then we won't be able to remove either name!

Let's stick with what we have and not add endless numbers of aliases for
every possible naming convention.

Cheers,
	-Matt Helsley
