Return-Path: <linux-kernel-owner+w=401wt.eu-S932966AbZACX6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966AbZACX6r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 18:58:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbZACX6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 18:58:38 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:20363 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbZACX6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 18:58:37 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=N2G1neSFK1Q7JptIix8A:9 a=pqvsJMGwQsr7YhJQNwX6g-oB4yIA:4
Message-ID: <495FFBA8.10804@shaw.ca>
Date: Sat, 03 Jan 2009 17:58:32 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
Newsgroups: gmane.linux.documentation,gmane.linux.kernel
To: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@ribosome.natur.cuni.cz>
CC: Duane Griffin <duaneg@dghda.com>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, tytso@mit.edu, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
References: <20090103123813.GA1512@ucw.cz>	 <495FD5D7.2040907@ribosome.natur.cuni.cz>	 <e9e943910901031417m51c847fepf304650862f0cbc2@mail.gmail.com>	 <20090103222957.GG1666@elf.ucw.cz>	 <495FEE66.9080903@ribosome.natur.cuni.cz> <e9e943910901031538m24ff9616na2aaf3a57f161655@mail.gmail.com> <495FF9CE.2020908@ribosome.natur.cuni.cz>
In-Reply-To: <495FF9CE.2020908@ribosome.natur.cuni.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin MOKREJŠ wrote:
> Duane Griffin wrote:
>> 2009/1/3 Martin MOKREJŠ <mmokrejs@ribosome.natur.cuni.cz>:
>>> Hmm, so if my dual-boot machine does not shutdown correctly and I boot
>>> accidentally in M$ Win where I use ext2 IFS driver and modify some
>>> stuff on the ext3 drive, after a while reboot to linux and the journal
>>> get re-played ... Mmm ...
>> You *really* wouldn't want to be doing that.
>>
>> The other scenario that people have reported trouble with is
>> suspending the system, booting a live CD which "read-only" mounts the
>> filesystem (and replays the journal), then resuming.
> 
> Why does not "mount -ro" die when it would have to replay the journal
> with a message that user must run fsck.ext3 in order to be able to mount
> it albeit read-only? Still I would prefer having an extra switch to

That would break typical system bootup in the unclean journal case, 
normally the root FS is mounted read-only to start with (which replays 
the journal) and remounted read-write later on - and usually the fsck 
utilities are located on the root filesystem..

> force mount RO while not touching the journal for disk forensics.
> I think that would also prevent the cases when a LiveCD/rescue distribution
> would not mount+replay it automagically but user would really have to
> provide the switch to the command. I am really not using the recovery
> boot cd to touch my partitions in some cases unwillingly.

I agree, there should be a way to force it to mount "really read only" 
so it doesn't try to replay the journal. That might require just 
ignoring the journal content, which may result in the FS appearing 
corrupt, but for recovery/forensics purposes that seems better than 
nothing..
