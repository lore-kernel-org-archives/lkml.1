Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbZJPGbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbZJPGbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 02:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbZJPGbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 02:31:44 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:59699 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbZJPGbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 02:31:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AKQ/2XvCgeY94IaOjQgauTkLIwr7CZ6BMAXLC8HQ0v/7nfs1qH6i8EWAmhFMrWnHhR
         ay4SG48Hca9o6KF4uoCzKpKWrkX8Om8TYH8O5hv02ys//kTwhMXQIRNuaOzCEfEkgn7S
         RNMyJ5/Hijt6KaXGxbacq2IJFT+74LYq7V0qY=
Subject: Re: ext4 increased intolerance to unclean shutdown?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, tytso@mit.edu
In-Reply-To: <f7848160910152128h96237b7ga103915082d6412b@mail.gmail.com>
References: <f7848160910152128h96237b7ga103915082d6412b@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 16 Oct 2009 08:31:01 +0200
Message-Id: <1255674661.14475.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 00:28 -0400, Parag Warudkar wrote:
> So I have been experimenting with various root file systems on my
> laptop running latest git. This laptop some times has problems waking
> up from sleep and that results in it needing a hard reset and
> subsequently unclean file system.
> 
> Initially I had ext3 on and never really had any visible filesystem
> issues for quite some time even with hard resets after wakeup. Then I
> switched to ext4 and first time it failed to wakeup from sleep fsck
> took me through quite a bit of errors - but after fixing them it
> immediately went and hit EXT4-fs error and it was unusable there
> onwards until (if I recall correctly) I found the file path associated
> with the inode relating to that message and used debugfs to delete the
> file only to have segfaults on subsequent boot. That was some time
> ago.
> 
> Meanwhile I was running xfs root and had the laptop fail to wakeup a
> fair number of times with no visible file system related issue.
> 
> This evening I needed to secure erase the abused SSD and that gave me
> a chance to retry ext4. But as bad luck would have it, the laptop just
> failed to wakeup and had to be reset. Sure enough, a ton of errors
> needed to be fixed when fsck went through the ext4 root fs. I had
> /boot as 8gb ext3 on same disk and that one showed no errors. But the
> bad part was it still failed to boot to desktop (GDM could not write
> to authorization file) after repairing the ext4 root fs. I forced
> another fsck on the root fs and it (again) found another handful of
> things to fix. So now it boots to desktop but some startup service
> still fails to start or stop.
> 
> So what's going on? I understand all bets are off when you have to
> hard reset - but based on my anecdotal experience it seems to me like
> ext4 has grown more intolerant to unclean shutdowns. Is this to be
> expected or it's just sheer coincidence?
> 
> Curious to understand the reason if any - don't care about the data
> loss part, as I had purposefully not kept anything important on the
> filesystems.

I had similar experience, and I say it all begin in 2.6.32.
see, http://marc.info/?l=linux-kernel&m=125486358632602&w=2

In fact I had never seen ext3/4 fsck in action before.


Best regards,
	Maxim Levitsky





> 
> Thanks
> 
> Parag
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

