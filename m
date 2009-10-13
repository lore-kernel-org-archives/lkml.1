Return-Path: <linux-kernel-owner+w=401wt.eu-S1759878AbZJMNmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759878AbZJMNmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 09:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbZJMNmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 09:42:11 -0400
Received: from 207-172-69-77.c3-0.smr-ubr3.sbo-smr.ma.static.cable.rcn.com ([207.172.69.77]:40248
	"EHLO thaum.luto.us" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbZJMNmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 09:42:10 -0400
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Oct 2009 09:42:10 EDT
Message-ID: <4AD481A4.6040706@mit.edu>
Date: Tue, 13 Oct 2009 09:33:24 -0400
From: Andy Lutomirski <luto@mit.edu>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Shawn Starr <shawn.starr@rogers.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.32-rc4] + EXT4 corruption
References: <200910122207.50140.shawn.starr@rogers.com> <20091013022301.GC2606@mit.edu>
In-Reply-To: <20091013022301.GC2606@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Mon, Oct 12, 2009 at 10:07:49PM -0400, Shawn Starr wrote:
>> Hello everyone, 
>>
>> I somehow managed to corrupt some of my filesystem.
>>
>> What I did was this:
>>
>> in /etc/modprobe.d/alsa-base.conf (Kubuntu)
>>
>> I added:
>>
>> install snd-aloop /sbin/modprobe snd-aloop
>>
>> Saved it, then ran, modprobe snd-aloop, the system started spawning
>> many copies of modprobe, then machine started going though a swap
>> storm, could not reboot safely, hit power button on laptop. When the
>> system came back up, EXT4 greeted me with severe errors on some
>> opened files. It did repair filesystem however. It corrupted some
>> configuration files that were open at the time of the shutdown.
>>
>> I'm guessing no matter how much you attempt to replay a journal you
>> still can get corruption such as this?
> 
> You shouldn't get any file system corruption after replaying a
> journal.  I'm trying to get an easily reproducible test case for this.
> Can you give me more information about where your root filesystem is
> located.  Is it using LVM?  dm-crypt?  Can you reliably reproducible
> the file system corruption?

I triggered what might have been the same bug awhile ago on 2.6.32-rc2 
or so (with your patch to fix a writepages OOPS applied, I think).  I 
crashed my system by doing something dumb with the i915 driver, and, 
after power cycling, I had all kinds of corrupt inodes.  e2fsck fixed it 
  just fine and only lost /etc/ld.so.cache.

This was LVM over dm-crypt on a partition on AHCI on a real (non-SSD) 
hard disk.

--Andy

> 
> 						- Ted
> 
> 
> 					

