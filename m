Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287Ab0CNOw5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 10:52:57 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:55873 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab0CNOw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 10:52:56 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH vfat] IOMEGA network drive compatibility
References: <20100310161429.GA16799@frolo.macqel>
	<87hboow105.fsf@devron.myhome.or.jp>
	<20100310235808.GA4353@frolo.macqel>
	<87bpevryxt.fsf@devron.myhome.or.jp>
	<20100311120214.GA23767@frolo.macqel>
	<87y6hzni82.fsf@devron.myhome.or.jp>
	<20100313113150.GA11907@frolo.macqel>
	<87wrxg9xri.fsf@devron.myhome.or.jp>
	<20100314103924.GA3712@frolo.macqel>
	<87r5nnqhit.fsf@devron.myhome.or.jp>
	<20100314141328.GA7712@frolo.macqel>
Date: Sun, 14 Mar 2010 23:52:51 +0900
In-Reply-To: <20100314141328.GA7712@frolo.macqel> (Philippe De Muyter's
	message of "Sun, 14 Mar 2010 15:13:29 +0100")
Message-ID: <87bperoszg.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philippe De Muyter <phdm@macqel.be> writes:

>> Because it's wrong entry as fatfs. In this situation, user needs to
>> repair by tools (e.g. fsck), so it's not responsibility of fs driver.
>
> I know that entries with trailing dots are "invalid" fatfs entries,
> but 1) linux/vfat currently accept such entries silently without truncating
> them and 2) IOMEGA disks present themselves as fatfs disks.  Who are we to
> tell the opposite ?  And IOMEGA integrated scandisk (accessible via the
> web interface) does not find any error in its filesystem.

You can create many files points to one cluster chain. It is silently
accepted by current fatfs driver. But, it's a broken fs image like this.

>> Now, you try to change that design. So, you need to change/think more
>> high level consistency/design, not just workaround. Otherwise, it'll be
>> unmaintainable/unfixable.
>
> I am sorry but I don't see anything unmaintainable/unfixable in my patch :
> it is very small and localized and it only allows accessing existing
> entries with trailing dots, nothing more.
>
> It does not allow to create "invalid" entries, so it does not change the
> behaviour for "strict" vfat disks, it only introduces a small time penalty
> when a user tries to access a file using a different name that the one stored
> in the directory, which happens very rarely : most linux users use GUI's or
> bash tab-completion to access files, which implies they use the name given by
> the file-system driver, not a variation of it.
>
> Now if we are concerned about "editing" such files by creating a temporary
> file and renaming, we can look at what is needed to make renaming to an
> existing name containing trailing dots succeed.  I have not tested that yet.
>
> For the rest, i.e. creating arbitrary names with trailing dots just like
> what IOMEGA drives do, it can be with a mount option, or left as it is
> now : impossible.

I already reported the one of bugs at least, and it seems you already
can't fix it, or just ignored it.

You are always saying "I'm fine with this". But I disagree, and I know
this fs is not only for just desktop users.  If this is only for you
usage, I'm sorry, but please apply it yourself.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
