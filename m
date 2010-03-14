Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963Ab0CNLRi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 07:17:38 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:43599 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab0CNLRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 07:17:35 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH vfat] IOMEGA network drive compatibility
References: <20100310123257.GA2899@frolo.macqel>
	<87d3zc1bjo.fsf@devron.myhome.or.jp>
	<20100310161429.GA16799@frolo.macqel>
	<87hboow105.fsf@devron.myhome.or.jp>
	<20100310235808.GA4353@frolo.macqel>
	<87bpevryxt.fsf@devron.myhome.or.jp>
	<20100311120214.GA23767@frolo.macqel>
	<87y6hzni82.fsf@devron.myhome.or.jp>
	<20100313113150.GA11907@frolo.macqel>
	<87wrxg9xri.fsf@devron.myhome.or.jp>
	<20100314103924.GA3712@frolo.macqel>
Date: Sun, 14 Mar 2010 20:17:30 +0900
In-Reply-To: <20100314103924.GA3712@frolo.macqel> (Philippe De Muyter's
	message of "Sun, 14 Mar 2010 11:39:24 +0100")
Message-ID: <87r5nnqhit.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philippe De Muyter <phdm@macqel.be> writes:

> You can call that a hack, but it certainly is better than the current situation.
> IOMEGA network drive firmware allows to create two files in the same directory
> differing only by the trailing dots.  Suppose you have in the same directory
> a file called "123456789" and a file called "123456789." (same name + a
> trailing dot).  When afterwards connected via USB to a linux computer,
> ls or any GUI equivalent will show you two files, one called "123456789"
> and one called "123456789.".  If you compare those two files, linux/vfat
> will tell you that they are equal, because the vfat driver will wrongly
> access twice the same "123456789" file and never the "123456789." file.
>
> -rwxr-xr-x 1 phdm root     1 2009-10-15 23:44 123456789
> -rwxr-xr-x 1 phdm root     1 2009-10-15 23:44 123456789.
>
> If you then decide to remove the "123456789." file (the one with the
> trailing dot), because it is an useless copy of your "123456789" file,
> linux/vfat will silently remove the "123456789" file.  Afterwards,
> if you're lucky, you'll see ls complain :
>
> 	ls: cannot access a.: No such file or directory
>
> , but some GUI interfaces won't say anything.
>
> In the listing, ls will show :
>
> -????????? ? ?    ?        ?                ? 123456789.
> (The "123456789" does not appear anymore)
>
> but again some GUI won't even show you the name of the "123456789." file

Because it's wrong entry as fatfs. In this situation, user needs to
repair by tools (e.g. fsck), so it's not responsibility of fs driver.

> With my proposed patch, at least if getdents tells a user program that
> there is a "123456789." entry, further references by open and friends
> will access precisely that entry, not another one.  That at least needs to
> be fixed, without any option that the user should give to mount.

Now, you try to change that design. So, you need to change/think more
high level consistency/design, not just workaround. Otherwise, it'll be
unmaintainable/unfixable.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
