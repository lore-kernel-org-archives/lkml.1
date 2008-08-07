Return-Path: <linux-kernel-owner+w=401wt.eu-S1758528AbYHGMeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528AbYHGMeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbYHGMeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:34:06 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:44695 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbYHGMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:34:04 -0400
Date: Thu, 7 Aug 2008 13:13:57 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "D. Kelly" <user.kernel@gmail.com>
Cc: "mailing list: linux-kernel" <linux-kernel@vger.kernel.org>,
       Linux I2C <i2c@lm-sensors.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Problem with restricted I2C algorithms in kernel 2.6.26!
Message-ID: <20080807131357.59399ddf@hyperion.delvare>
In-Reply-To: <5ab239b10807161233i6c1c4d0we01ea1b8e6ccaa5b@mail.gmail.com>
References: <5ab239b10807161233i6c1c4d0we01ea1b8e6ccaa5b@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Sorry for the late answer, I am just back from vacation.

On Wed, 16 Jul 2008 12:33:57 -0700, D. Kelly wrote:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=3845de25c5f83cd52729570f7b501679d37ca8de
> 
> The patch at the preceeding url disables the users ability to select
> I2C algorithms.  Specifically the reason stated was:
> 
> "The algorithm drivers are
> helper drivers that are selected automatically
> as needed. There's no point in listing them in the config menu, it can
> only confuse users and waste their time."
> 
> The algorithm drivers will not be 'selected automatically as needed'
> if the user is compiling something outside of the kernel that requires
> them!  Just one example, there are drivers found in the V4L dvb driver
> tree that require i2c bit-banging be enabled.  The drivers are now
> broken because the user is not allowed to enable bit-banging himself.
> The only way around this is to revert the patch manually or enable
> something else in the kernel, that he doesn't need, just to get
> bit-banging.

Note how bad a user experience this is in the first place: not only the
users don't get their driver directly in the kernel tree, but they also
need to follow specific instructions about how to configure the kernel
for said driver to build externally. This can be automated for drivers
which live in the kernel tree.

A 3rd way around this is to simply merge the driver in question in the
upstream kernel. This makes things much easier for kernel maintainers,
drivers authors and end users.

Alternatively, I am curious if our build system couldn't allow 3rd
party drivers to select in-tree modules. Obviously this would require
the complete kernel source tree to be available, instead of just the
header and config files as is usually the case. Sam, is this possible
to do that at this time? If not, is this something that could be
implemented, or is this too much work for the thin benefit?

> It's a very bad idea to assume that nothing built outside of the
> kernel may need i2c algorithms.  Furthermore, the whole point of being
> able to customize your kernel is so you can select only the things
> which you need.  It makes no good sense to intentionally
> disable/restrict the users ability to do so.  Additionally, assuming
> the ability to select i2c algorithms will only confuse the user and
> waste their time is ridiculous.  The user should be allowed to decide
> for himself what he needs regarding this!

You obviously haven't been the i2c subsystem maintainer for years. I
have been, and clearly remember users repeatedly asking about these
options. More generally, the kernel configuration menu has grown over
the past few years to a point where newcomers can hardly make their way
through all the options. Greg KH's "Linux kernel in a nutshell" helps a
bit, but still, making the kernel configuration as simple as possible
still stands as a valid goal.

> One of the biggest reasons people choose to compile things from
> cvs/svn/mercurial/etc. is because it gives them access to newer bug
> fixes and support for things not yet present in the kernel source.  A
> perfect example, the multiproto dvb driver tree.  Users wanting
> support for dvb-s2 devices have to compile drivers outside of the
> kernel because it's simply not available in the kernel and won't be
> for some time.

So basically you are telling that "thanks" to drivers being maintainers
in external repositories, bugs are not fixed in the upstream kernel in
a timely manner, and new features take more time to go there too? That
must be the reason why kernel developers and users alike don't like
external repositories in the first place.

And please don't tell me how some drivers "must" live in external
repositories. They just don't. In almost all cases that's a poor
decision by the driver author, period.

> I've contacted one of the i2c subsystem maintainers, Jean Delvare, but
> unfortunately he doesn't seem to care about this problem and his
> advice in dealing with it is to "Just get these drivers merged in the
> kernel. Ah ah ah!"...

Quoting people out of context and without their permission isn't fair.
You forget to mention that you contacted me anonymously, boldly claimed
that the 2.6.26 kernel was broken, omitted to explain exactly how the
change in question was a problem to you, and insulted me later in the
course of the discussion. So you received the treatment you deserved
(i.e. I ignored you.)

> Clearly the more sane and reasonable solution is to not cripple the
> menu options in the first place, especially when it creates no benefit
> and only serves to limit/restrict the users ability to select what he
> needs.  I'm asking that the patch be reverted and anyone in agreement
> to please voice their opinion here in public.

That was 3 weeks ago and apparently nobody spoke in your favor. So
either nobody cares, or everyone is on vacation. Or both.

Note though that bug #11140 has been created for the same issue:
http://bugzilla.kernel.org/show_bug.cgi?id=11140

-- 
Jean Delvare
