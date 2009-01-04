Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbZADDX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbZADDX4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 22:23:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbZADDXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 22:23:47 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:14194 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbZADDXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 22:23:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=wLmRBMFdmlmRaEf7KqoAX/2fHyZmyWdlizPUjtooy93bV3UinWLF/kMZTcAdphjQaF
         5dZVCutSZIqnwBxgJFHcl1nHZxvhFP6KkmenuiWs+NOC27OzYRe3bx4vdzS/Zdc3pxmR
         0DkiUpKnPeyanxh3aa4+GKfmlUxpdPVqtmnBE=
Message-ID: <12bfabe40901031923r3a828f71v74a8c6a56746b2ec@mail.gmail.com>
Date: Sun, 4 Jan 2009 04:23:42 +0100
From: "Giangiacomo Mariotti" <gg.mariotti@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Half-Disaster switching from ext3 to ext4
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently compiled and booted kernel v2.6.28 and decided to test
ext4. After some formatting without problems, I decided to migrate my
partitions from ext3 to ext4. I did  the following to a non-important
partition, just to test it : tune2fs -O extents,uninit_bg,dir_index
/dev/name_of_partition ; fsck -pf /dev/name_of_partition. Everything
went smoothly without any problem, so I did this to other partitions,
in inverted order of importance. No problem at all. I used them, after
having remounted them as ext4 file-systems, without any problem at
all, no problems logged, nothing on dmesg, except for the normal
messages. Then I had to power down the pc, so I manually umounted all
the partitions(except for root obviously), I synced some times before
doing that and then I shut down the pc with a "shutdown -h -P now".
when I booted again the system, /dev/sda2(the partition with the most
important data. Murphy's law really works!) failed to get mounted with
a message saying something about corrupted groups(maybe, I don't
remember exactly). Trying to do a fsck.ext4 -p /dev/sda2, I got
something like : fsck.ext4 : Invalid argument while checking ext3
journal for /dev/sda2. So the fsck didn't help. Notice that nothing
had happened to cause this problem, the system had worked normally
before powering it down, even that partition didn't have any problem.
So I did this :
"mkfs.ext3 -c -c -n /dev/sda2"(the original command used to make the
fs + -n) to find the backup superblocks and then I used one from
them(randomly) to do "fsck.ext4 -p -b 'buckup-sb' /dev/sda2". Now fsck
worked and it found again checksum errors in group descriptors, like
when I switched the fs to ext4 and then it told me that the fs had
errors so I had to do a manual fsck. I did that(the manual part is
annoying and useless! How am I supposed to know what to do with what's
on block *, or whatever? Just ask at the beginning if I want to do it
manually or not, because most of the times I'd still say yes to all
the questions. Waste of time!), I repaired the fs which at the end,
after the manual cleaning resulted finally clean. After having
remounted it, all files were gone! I was starting to use the sleuth
kit, when I noticed that in the search+found directory there were
almost all the files, but not all of them and in a rearrenged
directory structure. Meanwhile all the other partitions which I
switched from ext3 to ext4 had no problem at all, and even for
/dev/sda2 no problem got logged, nor did the system switch off in a
bad manner. So, what the hell happened?

Thanks,
Giangiacomo
