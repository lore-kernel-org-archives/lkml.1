Return-Path: <linux-kernel-owner+w=401wt.eu-S1761229AbZJMUU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761229AbZJMUU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761215AbZJMUU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:20:58 -0400
Received: from smtp130.rog.mail.re2.yahoo.com ([206.190.53.35]:32896 "HELO
	smtp130.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753636AbZJMUU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:20:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=dDSW65rCQD+rPc7rGwhPard11zhho8dlJsrX6uBMsNcnHiDnZ/uHcgKP+KuDyUOmerAoR0DoVrIJsa9Cc8Nep4T1e9WGM3fGP7995gstmtMcsKlEmVuDep8VBms07vGktMi+Q4Cr0K+69PdDL48OUhyKcajdAO1MWRuCgXi4o8E=  ;
X-YMail-OSG: Hq8kXF8VM1mJyHXNjnLVwYcoWBvZXQ9daJZFd6e3Scjp.eM4UkFxXzs5m5AyKVAbnQ--
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
To: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.32-rc4] + EXT4 corruption
Date: Tue, 13 Oct 2009 16:20:12 -0400
User-Agent: KMail/1.12.90 (Linux/2.6.32-rc4-custom; KDE/4.3.69; x86_64; svn-1027797; 2009-09-23)
References: <200910122207.50140.shawn.starr@rogers.com> <20091013022301.GC2606@mit.edu>
In-Reply-To: <20091013022301.GC2606@mit.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910131620.12676.shawn.starr@rogers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On October 12, 2009 10:23:01 pm Theodore Tso wrote:
> On Mon, Oct 12, 2009 at 10:07:49PM -0400, Shawn Starr wrote:
> > Hello everyone,
> >
> > I somehow managed to corrupt some of my filesystem.
> >
> > What I did was this:
> >
> > in /etc/modprobe.d/alsa-base.conf (Kubuntu)
> >
> > I added:
> >
> > install snd-aloop /sbin/modprobe snd-aloop
> >
> > Saved it, then ran, modprobe snd-aloop, the system started spawning
> > many copies of modprobe, then machine started going though a swap
> > storm, could not reboot safely, hit power button on laptop. When the
> > system came back up, EXT4 greeted me with severe errors on some
> > opened files. It did repair filesystem however. It corrupted some
> > configuration files that were open at the time of the shutdown.
> >
> > I'm guessing no matter how much you attempt to replay a journal you
> > still can get corruption such as this?
> 
> You shouldn't get any file system corruption after replaying a
> journal.  I'm trying to get an easily reproducible test case for this.
> Can you give me more information about where your root filesystem is
> located.  Is it using LVM?  dm-crypt?  Can you reliably reproducible
> the file system corruption?
> 
> 						- Ted
> 

Hi Ted, 

No LVM, no encryption. Regular primary partitions. root is on sda4, swap on 
sda3, /boot is on sda2, sda1 contains another OS that came with laptop.

/ is mounted as: 
/dev/sda4 on / type ext4 (rw,noatime,nodiratime,errors=remount-ro)

Some more information:

I was in X with several KDE and non-KDE applications at the time of the swap 
storm. I noticed in my .viminfo file contents got corrupted with of some .kde4 
configurations (looks to be a plasma configuration), lost my kconversationrc 
completely.  That file is was also in $HOME/.kde4/config. 

fsck.ext4 asked me if I wanted to clone some inodes and truncate illegal ones. 
I said yes to all the warnings (too bad it doesn't have a log of that anywhere 
I could give you).

It might be useful to have fsck write a log file to filesystem after its 
cleaned, then one could provide you a full dump of what fsck says and what 
EXT4 spits out?

I am pretty sure I can reproduce the corruption. I am more surprised that 
opened files such as .viminfo were corrupted when they are not being changed? 
(I don't believe vim examines the file if you've loaded it once during start 
of vim?)

Thanks, 
Shawn.
