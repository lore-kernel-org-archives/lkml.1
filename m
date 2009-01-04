Return-Path: <linux-kernel-owner+w=401wt.eu-S932778AbZADAI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778AbZADAI1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 19:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760084AbZADAIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 19:08:17 -0500
Received: from ribosome.natur.cuni.cz ([195.113.57.20]:38510 "EHLO
	ribosome.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759891AbZADAIQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 19:08:16 -0500
Message-ID: <495FFDEE.8030304@ribosome.natur.cuni.cz>
Date: Sun, 04 Jan 2009 01:08:14 +0100
From: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@ribosome.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081227 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Duane Griffin <duaneg@dghda.com>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, tytso@mit.edu, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
References: <20090103123813.GA1512@ucw.cz>	 <495FD5D7.2040907@ribosome.natur.cuni.cz>	 <e9e943910901031417m51c847fepf304650862f0cbc2@mail.gmail.com>	 <20090103222957.GG1666@elf.ucw.cz>	 <495FEE66.9080903@ribosome.natur.cuni.cz> <e9e943910901031538m24ff9616na2aaf3a57f161655@mail.gmail.com> <495FF9CE.2020908@ribosome.natur.cuni.cz> <495FFBA8.10804@shaw.ca>
In-Reply-To: <495FFBA8.10804@shaw.ca>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Martin MOKREJŠ wrote:
>> Duane Griffin wrote:
>>> 2009/1/3 Martin MOKREJŠ <mmokrejs@ribosome.natur.cuni.cz>:
>>>> Hmm, so if my dual-boot machine does not shutdown correctly and I boot
>>>> accidentally in M$ Win where I use ext2 IFS driver and modify some
>>>> stuff on the ext3 drive, after a while reboot to linux and the journal
>>>> get re-played ... Mmm ...
>>> You *really* wouldn't want to be doing that.
>>>
>>> The other scenario that people have reported trouble with is
>>> suspending the system, booting a live CD which "read-only" mounts the
>>> filesystem (and replays the journal), then resuming.
>>
>> Why does not "mount -ro" die when it would have to replay the journal
>> with a message that user must run fsck.ext3 in order to be able to mount
>> it albeit read-only? Still I would prefer having an extra switch to
> 
> That would break typical system bootup in the unclean journal case,
> normally the root FS is mounted read-only to start with (which replays
> the journal) and remounted read-write later on - and usually the fsck
> utilities are located on the root filesystem..

Couldn't that be handled by e.g. openRC during boot, to provide the
say to be provided --force-journal-replay during "normal" boot?
Yes, that would mean e2fsprogs would become incompatible with older
versions but why not "fix" the logic?

> 
>> force mount RO while not touching the journal for disk forensics. I
>> think that would also prevent the cases when a LiveCD/rescue 
>> distribution would not mount+replay it automagically but user would
>> really have to provide the switch to the command. I am really not
>> using the recovery boot cd to touch my partitions in some cases
>> unwillingly.
>
> I agree, there should be a way to force it to mount "really read only"
> so it doesn't try to replay the journal. That might require just
> ignoring the journal content, which may result in the FS appearing
> corrupt, but for recovery/forensics purposes that seems better than
> nothing..

Fully agree.

M.

