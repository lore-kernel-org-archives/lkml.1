Return-Path: <linux-kernel-owner+w=401wt.eu-S933410AbZJFVHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410AbZJFVHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933385AbZJFVHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:07:38 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:63571 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933008AbZJFVHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:07:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Mvm0mMMyt0UiD9PfSHkMe8lOqxH0R63e4uj0n702XgVqPCp5ICKxp84Dr4IGKDGgYh
         GQOr4I2SS+hb8m2mH0O2Y0mMVGD2jiYGT1HMCB3VPQ6Sqc5uLE+0vYyvmeua7xePbIeT
         U/UH5GhmEfWfP4lPX8qtpqABL0fJNrkR+Atvo=
Subject: Massive ext4 filesystem corruption after a failed s2disk/ram cycle
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Oct 2009 23:06:55 +0200
Message-Id: <1254863215.11577.23.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just prior to 2.6.32 cycle I tried -next tree and noticed that after a
failed s2ram (here it works only once, and I test once in a whileto see
if fixed accidentally) I got a minor filesystem corruption. I am sorry I
didn't report that back then.

Now I have installed 2.6.32-rc2 (well -rc1...) and things were sort of
ok, I have even thought that hibernation is once again stable
(somewhere in the not that distinct past the hibernation which used to
work, began to fail randomly on resume)

Few days ago, I got a read-only filesystem again, an fsck, few more
corrupted files..., It should have had rung the bell for me (I have
still used hibernation, trying to understand why it fails sometimes)

Yesterday, however, I have decided to fix that once and for all, and for
that I have set up a loop + rtc wakealarm to make it cycle through
hibernation.

Needless to say I didn't run that loop more that maybe 3 cycles (and no
failures), but noticed that rtc clock is dead on resume. 

I sort of fixed that (this is hpet emulation that strikes again), I will
post when I test the fix (trivial), because when I had rebooted the
system into the modified kernel, I got that readonly filesystem again,
and this time the damage had spread over lots of files.
(I have even lost most of dpkg database..., many programs,
libraries,..., settings)

Yet, thanks to Linux flexibility, after a day, and some study of
nautilus source, I had the system recovered fully.
(Now am doing backups.....)

But I don't want that to happen again...

Another clue that I have seen was that ext4 driver reported that it
aborts journal replay.

I know that for now there is not much you can do, but just to let you
know that something is there...

What is especially interesting is that there were no s2ram'disk faulure
preceding the corruption, but my theory is that corruption wasn't
detected for a while from last failure, probably giving such bad
consequences.

You do sync file-systems before entering the hibernation, don't you?


Best regards,
Maxim Levitsky

