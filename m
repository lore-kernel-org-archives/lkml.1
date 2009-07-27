Return-Path: <linux-kernel-owner+w=401wt.eu-S1752737AbZG0O46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbZG0O46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 10:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbZG0O44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 10:56:56 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:42785 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbZG0O4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 10:56:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19053.49157.984140.286148@stoffel.org>
Date: Mon, 27 Jul 2009 10:56:05 -0400
From: "John Stoffel" <john@stoffel.org>
To: Jamie Lokier <jamie@shareable.org>
Cc: John Stoffel <john@stoffel.org>, Andreas Dilger <adilger@sun.com>,
       Ludwig Nussel <ludwig.nussel@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] implement uid mount option for ext2
In-Reply-To: <20090724231658.GM27755@shareable.org>
References: <1248348991-849-1-git-send-email-ludwig.nussel@suse.de>
	<1248431444-18842-1-git-send-email-ludwig.nussel@suse.de>
	<1248431444-18842-2-git-send-email-ludwig.nussel@suse.de>
	<20090724165201.GA4231@webber.adilger.int>
	<19050.1094.758320.38666@stoffel.org>
	<20090724231658.GM27755@shareable.org>
X-Mailer: VM 8.0.9 under Emacs 22.3.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jamie" == Jamie Lokier <jamie@shareable.org> writes:

Sorry for the delay, I was out of it this weekend... :]

Jamie> John Stoffel wrote:
>> I didn't read the original email closely, but I have to say that both
>> of these plans don't sound good to me.  If you can mount a filesystem,
>> you're root already, so you can do any fixup you need.

Jamie> What if someone lends you a 1TB disk, for you to browse it in
Jamie> your favourite GUI or Shell Window to read some files from it?
Jamie> And you're to put a couple of files on it before you give it
Jamie> back?

So?  How is the kernel supposed to know you're doing this?

Jamie> Hotplug scripts run as root to mount it, and you have your GUI
Jamie> / Shell Window which don't run as root to read and write a few
Jamie> of those files.

Jamie> You must not chown anything on the disk, because it isn't your
Jamie> disk.

Umm... this doesn't make sense.  If it's not your disk, why are you
writing to it?  And how is chown different? 

The real answer is that your buddy should have setup a mode 777
directory on there where random stuff could be dropped.  Again, a
userspace issue, not kernel.

>> But in that case, you're screwed anyway and it's going to become
>> un-manageable.  Push this to userspace, not the kernel since it's a
>> userspace issue when you come right down to it.

Jamie> How do you handle the above scenario in userspace?

You certainly can't handle this in kernel space!  If you just plug in
a random disk, and it comes up with borked UIDs because the original
server it came from has a different setup than yours for UID/GIDs,
then you're going to have to do *something* in a manual manner to fix
it.

Either you need to 'sudo chown -R user /media/disk/' or better yet
just mkdir a new directory with appropriate permissions and then write
using your GUI/shell-window, non-root user account to that new
directory.

Putting in a mount option like this is just begging for all kinds of
issues.

John

