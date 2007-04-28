Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbXD1TJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbXD1TJh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbXD1TJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:09:37 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754090AbXD1TJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:09:23 -0400
Date: Sat, 28 Apr 2007 12:08:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: cbou@mail.ru
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       David Woodhouse <dwmw2@infradead.org>, Greg KH <gregkh@suse.de>
Subject: Re: [ANNOUNCE] battery2 git repository
Message-Id: <20070428120804.67098b2c.akpm@linux-foundation.org>
In-Reply-To: <20070428123129.GA2056@zarina>
References: <20070426232902.GA10423@zarina>
	<20070428045148.9f1ba191.akpm@linux-foundation.org>
	<20070428123129.GA2056@zarina>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007 16:31:29 +0400 Anton Vorontsov <cbou@mail.ru> wrote:

> On Sat, Apr 28, 2007 at 04:51:48AM -0700, Andrew Morton wrote:
> > On Fri, 27 Apr 2007 03:29:02 +0400 Anton Vorontsov <cbou@mail.ru> wrote:
> > 
> > > To not confuse with David own battery-2.6 repository, it's called
> > > battery2-2.6, and can be found here:
> > > 
> > > http://git.infradead.org/?p=users/cbou/battery2-2.6.git;a=summary
> > > 
> > > You can get it using "git clone --reference linux-2.6 \
> > > git://git.infradead.org/users/cbou/battery2-2.6.git" command.
> > 
> > i386 `make allmodconfig':
> > 
> > ERROR: "battery_is_external_power_supplied" [drivers/battery/ds2760_battery.ko] undefined!
> > ERROR: "battery_unregister" [drivers/battery/ds2760_battery.ko] undefined!
> > ERROR: "battery_register" [drivers/battery/ds2760_battery.ko] undefined!
> > ERROR: "battery_status_changed" [drivers/battery/ds2760_battery.ko] undefined!
> 
> :-/
> 
> It should be fixed 37 hours ago by
> 
> http://git.infradead.org/?p=users/cbou/battery2-2.6.git;a=commit;h=cbb1e1b9e3a2cbf62ce4c13ef95d146ebc5e7274

I had that.  I just did a fresh fetch and it still happens

akpm2:/usr/src/25> cd /usr/src/git26
akpm2:/usr/src/git26> cat .git/branches/git-battery 
git://git.infradead.org/users/cbou/battery2-2.6.git
akpm2:/usr/src/git26> git-fetch git-battery
akpm2:/usr/src/git26> git-checkout git-battery 
Switched to branch "git-battery"
akpm2:/usr/src/git26> setenv ARCH i386
akpm2:/usr/src/git26> make allmodconfig > /dev/null
akpm2:/usr/src/git26> make vmlinux modules
...
WARNING: "battery_is_external_power_supplied" [drivers/battery/ds2760_battery.ko] undefined!
WARNING: "battery_unregister" [drivers/battery/ds2760_battery.ko] undefined!
WARNING: "battery_register" [drivers/battery/ds2760_battery.ko] undefined!
WARNING: "battery_status_changed" [drivers/battery/ds2760_battery.ko] undefined!
make[1]: *** [__modpost] Error 1

> Should I ask git-pull when such fixes happens?

No thanks.  I pull all the git trees approximately once per day.

> And I wonder why it isn't
> already in -mm, because you've added this git repository after that
> commit...

Yes, I had it all.

> Though, I'm doing "allmodconfig" once again, to be sure, it will take
> some time. (I've done defconfig, with modular W1, BATTERY,
> DS2760_BATTERY already, and error doesn't show up).
> 

You did `make vmlinux modules'?

> 
> Also, much thanks for accepting it to the -mm.
> 
> I have one question though... battery2-2.6 have two branches,
> "linus" (clean Linus' tree) and "master" (with battery stuff).

hm, I'm not using the "battery" branch.  Should I?

akpm2:/usr/src/git26> cat .git/branches/git-battery 
git://git.infradead.org/users/cbou/battery2-2.6.git

I tried
git://git.infradead.org/users/cbou/battery2-2.6.git#battery

but it doesn't exist.

> When I'll want to sync battery tree with Linus' once again,
> should I just pull from linus, or it's better to rebase master against
> linus, and then "git push -f" to the battery2-2.6 master branch?
> Or it will break something on your side (as commits will change their
> hash)?

I always do `git-branch -d git-battery' prior to every pull, so rebasings
like that are OK.
