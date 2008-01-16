Return-Path: <linux-kernel-owner+w=401wt.eu-S1757688AbYAPICg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688AbYAPICg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 03:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223AbYAPICZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 03:02:25 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:9377 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbYAPICY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 03:02:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=DkudRnd88vCFmcP70kRAKSBnYJdvWq/uM0DmwTyadmZfnoyj1w0Jg5QiyzGlkUe+4onoshOtqFmIKQRJqJirOfkyOzCPOrovBpALcQaQ0++8WwhWI386hFJbaYYiFExZ3N3ifYMVq+Ir1HEH2/3tr1IYvjbb+kpRGUKfY1JPnxY=
Message-ID: <478DB0E1.7090401@gmail.com>
Date: Wed, 16 Jan 2008 16:23:13 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Gabor Gombas <gombasg@sztaki.hu>, Greg KH <greg@kroah.com>,
       Dave Young <hidave.darkstar@gmail.com>,
       bluez-devel@lists.sourceforge.net
Subject: Re: [PATCH 2.6.24-rc7 2/2] sysfs: fix bugs in sysfs_rename/move_dir()
References: <478D74A6.7000206@gmail.com> <478D75BD.1010805@gmail.com> <alpine.LFD.1.00.0801151928380.2806@woody.linux-foundation.org> <20080116035224.GW27894@ZenIV.linux.org.uk>
In-Reply-To: <20080116035224.GW27894@ZenIV.linux.org.uk>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Al Viro wrote:
> No ACK is coming until we get something resembling analysis of locking
> scheme.  Which won't happen until we at least get the "what callers are
> allowed to do" written down, damnit.

I agree that sysfs needs further clean up.  As I wrote in the earlier
thread, sysfs has been under constant flux of cleanups and updates
although it has slowed down recently due to the hazy number of libata
bugs.  For example, several months ago with buggy dentry / inode
reclamation, sysfs could trigger pretty cryptic oopses under memory
pressure and locking was more awkward and buggy.

The two posted patches are bug fixes for apparent bugs which can be
triggered by the current two users of the interface.  AFAICS, locking
there is weird but correct for the current two users.  If you can find
any problem there, please lemme know.  We shouldn't hold this type of
fixes for future clean ups.

> As it is, I'm more than inclined
> to propose ripping kobject_move() out, especially since it has only two
> users - something s390-specific and rfcomm, with its shitloads of problems
> beyond just sysfs interaction.

Can you please elaborate?  All sysfs problems discovered by the rfcomm
are fixed by the posted patches.  Dave Young has a patch waiting for
verification by the tester.  Furthermore, even if we rip out
kobject_move() in the future, I don't think -rc7 is the right time to do it.

I posted some patches a while back which did sysfs locking
reorganization, separation from and proper layering with kobject /
driver model.  There were some disagreements regarding the interface and
I got struck by load of ATA bugs.  I'll dig it up and give it another
shot in a few weeks.

Thanks.

-- 
tejun

