Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307AbYGZHAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbYGZHAq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 03:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYGZHAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 03:00:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361AbYGZHAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 03:00:36 -0400
Date: Fri, 25 Jul 2008 23:59:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "D. Kelly" <user.kernel@gmail.com>
Cc: "mailing list: linux-kernel" <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>, i2c@lm-sensors.org
Subject: Re: Problem with restricted I2C algorithms in kernel 2.6.26!
Message-Id: <20080725235936.aeae8bc2.akpm@linux-foundation.org>
In-Reply-To: <5ab239b10807161233i6c1c4d0we01ea1b8e6ccaa5b@mail.gmail.com>
References: <5ab239b10807161233i6c1c4d0we01ea1b8e6ccaa5b@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's added)

On Wed, 16 Jul 2008 12:33:57 -0700 "D. Kelly" <user.kernel@gmail.com> wrote:

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
> 
> It's a very bad idea to assume that nothing built outside of the
> kernel may need i2c algorithms.  Furthermore, the whole point of being
> able to customize your kernel is so you can select only the things
> which you need.  It makes no good sense to intentionally
> disable/restrict the users ability to do so.  Additionally, assuming
> the ability to select i2c algorithms will only confuse the user and
> waste their time is ridiculous.  The user should be allowed to decide
> for himself what he needs regarding this!
> 
> One of the biggest reasons people choose to compile things from
> cvs/svn/mercurial/etc. is because it gives them access to newer bug
> fixes and support for things not yet present in the kernel source.  A
> perfect example, the multiproto dvb driver tree.  Users wanting
> support for dvb-s2 devices have to compile drivers outside of the
> kernel because it's simply not available in the kernel and won't be
> for some time.
> 
> I've contacted one of the i2c subsystem maintainers, Jean Delvare, but
> unfortunately he doesn't seem to care about this problem and his
> advice in dealing with it is to "Just get these drivers merged in the
> kernel. Ah ah ah!"...
> 
> Clearly the more sane and reasonable solution is to not cripple the
> menu options in the first place, especially when it creates no benefit
> and only serves to limit/restrict the users ability to select what he
> needs.  I'm asking that the patch be reverted and anyone in agreement
> to please voice their opinion here in public.
> 
> Best regards,
> -Derek

