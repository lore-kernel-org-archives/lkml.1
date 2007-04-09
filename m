Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbXDIQV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbXDIQV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 12:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbXDIQV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 12:21:28 -0400
Received: from smtpout.mac.com ([17.250.248.173]:54697 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541AbXDIQV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 12:21:27 -0400
In-Reply-To: <461A5F13.7040705@cfl.rr.com>
References: <20070409000556.GA13980@implementation> <461A5F13.7040705@cfl.rr.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <88E5C632-518E-487F-B39B-926407F5A70D@mac.com>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Add a norecovery option to ext3/4?
Date: Mon, 9 Apr 2007 12:20:58 -0400
To: Phillip Susi <psusi@cfl.rr.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 09, 2007, at 11:43:15, Phillip Susi wrote:
> Samuel Thibault wrote:
>> Hi,
>> Distribution installers usually try to probe OSes for building a  
>> suited grub menu.  Unfortunately, mounting an ext3 partition, even  
>> in read-only mode, does perform some operations on the filesystem  
>> (log recovery).  This is not a good idea since it may silently  
>> garbage data.  XFS has a norecovery option that allows to disable  
>> that, I'd say ext3/4 should have it too.
>
> When the filesystem is told to mount the disk read only, that means  
> it should not write to it.  The fact that ext3 goes ahead and does  
> anyway is a bug and should be fixed.  There is no need for a  
> norecovery option, because read only is a sufficient directive to  
> tell the filesystem not to write to the disk.
>
> As someone else pointed out, this behavior causes havoc if you  
> hibernate a system and then boot up another system which mounts the  
> disk of the hibernated system.  Under all conditions it should be  
> safe to mount a disk read only, but here it is not because the  
> journal playback trashes the disk out from under the hibernated  
> system.

Well IIRC it is possible to prevent that by switching the blockdev to  
read-only mode first:

root@ares:~# mount /dev/hda6 /mnt
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode
root@ares:~# umount /mnt
root@ares:~# blockdev --setro /dev/hda6
root@ares:~# mount /dev/hda6 /mnt
mount: block device /dev/loop0 is write-protected, mounting read-only
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode

Cheers,
Kyle Moffett

