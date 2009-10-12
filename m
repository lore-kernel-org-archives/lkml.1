Return-Path: <linux-kernel-owner+w=401wt.eu-S1758528AbZJLX3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528AbZJLX3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 19:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757627AbZJLX3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 19:29:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:2905 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZJLX3g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 19:29:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=GXQNdzJ0XQ6XynWvxDm6+MnAR/pZ7MltviXsYn8/AnyyY+Z0wE5rpSylyX44qNkxMR
         Au35XJxEwixD3WDRcYY75iFkMSM35HugrmqT4v3xBakxDm4YdibgcNV92Mr0tVW5UWzs
         ooLtdP3R4Um/yBFhl1DvwuxcoRR76qKp23RL0=
MIME-Version: 1.0
In-Reply-To: <20091012231211.GC18195@mit.edu>
References: <94a0d4530910120651i18ce33d2k89abcd66d1b865a1@mail.gmail.com>
	 <20091012222910.GB18195@mit.edu>
	 <94a0d4530910121602i14f34150h18d388668fc355d9@mail.gmail.com>
	 <20091012231211.GC18195@mit.edu>
Date: Tue, 13 Oct 2009 02:27:48 +0300
Message-ID: <94a0d4530910121627j74faac64l29169e17c0b2961b@mail.gmail.com>
Subject: Re: Weird ext4 bug: 256P used?
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Theodore Tso <tytso@mit.edu>,
       Felipe Contreras <felipe.contreras@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 2:12 AM, Theodore Tso <tytso@mit.edu> wrote:
> On Tue, Oct 13, 2009 at 02:02:31AM +0300, Felipe Contreras wrote:
>>
>> However, there's no file so big:
>> ls -lh /var/lib/yum/yumdb/s/160f96bb8689bae7bed1f8801385845d47913ace-skype-2.0.0.72-fc5-i586
>> total 12K
>> -rw-r--r-- 1 root root 24 2009-07-27 20:52 from_repo
>> -rw-r--r-- 1 root root  4 2009-07-27 20:52 reason
>> -rw-r--r-- 1 root root  2 2009-07-27 20:52 releasever
>>
>> However, there's something messed up with the uid/gid:
>>
>> ls -ld /var/lib/yum/yumdb/s/160f96bb8689bae7bed1f8801385845d47913ace-skype-2.0.0.72-fc5-i586
>> drwxr-xr-x 2 4294901760 16711680 4096 2009-07-27 20:52
>> /var/lib/yum/yumdb/s/160f96bb8689bae7bed1f8801385845d47913ace-skype-2.0.0.72-fc5-i586
>
> OK, how about the output of
>
> stat /var/lib/yum/yumdb/s/160f96bb8689bae7bed1f8801385845d47913ace-skype-2.\
> 0.0.72-fc5-i586

stat /var/lib/yum/yumdb/s/160f96bb8689bae7bed1f8801385845d47913ace-skype-2.0.0.72-fc5-i586
  File: `/var/lib/yum/yumdb/s/160f96bb8689bae7bed1f8801385845d47913ace-skype-2.0.0.72-fc5-i586'
  Size: 4096      	Blocks: 281470681743368 IO Block: 4096   directory
Device: fe00h/65024d	Inode: 141257      Links: 2
Access: (0755/drwxr-xr-x)  Uid: (4294901760/ UNKNOWN)   Gid: (16711680/ UNKNOWN)
Access: 2009-10-12 16:36:22.326920328 +0300
Modify: 2009-07-27 20:52:23.000000000 +0300
Change: 2009-07-27 20:52:23.000000000 +0300

> and
>
> stat /var/lib/yum/yumdb/s/160f96bb8689bae7bed1f8801385845d47913ace-skype-2.\
> 0.0.72-fc5-i586/*

stat /var/lib/yum/yumdb/s/160f96bb8689bae7bed1f8801385845d47913ace-skype-2.0.0.72-fc5-i586/*
  File: `/var/lib/yum/yumdb/s/160f96bb8689bae7bed1f8801385845d47913ace-skype-2.0.0.72-fc5-i586/from_repo'
  Size: 24        	Blocks: 8          IO Block: 4096   regular file
Device: fe00h/65024d	Inode: 144750      Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2009-07-27 20:52:23.931517024 +0300
Modify: 2009-07-27 20:52:23.931517024 +0300
Change: 2009-07-27 20:52:23.931517024 +0300
  File: `/var/lib/yum/yumdb/s/160f96bb8689bae7bed1f8801385845d47913ace-skype-2.0.0.72-fc5-i586/reason'
  Size: 4         	Blocks: 8          IO Block: 4096   regular file
Device: fe00h/65024d	Inode: 144824      Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2009-07-27 20:52:23.931517024 +0300
Modify: 2009-07-27 20:52:23.931517024 +0300
Change: 2009-07-27 20:52:23.931517024 +0300
  File: `/var/lib/yum/yumdb/s/160f96bb8689bae7bed1f8801385845d47913ace-skype-2.0.0.72-fc5-i586/releasever'
  Size: 2         	Blocks: 8          IO Block: 4096   regular file
Device: fe00h/65024d	Inode: 144913      Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2009-07-27 20:52:23.931517024 +0300
Modify: 2009-07-27 20:52:23.932517304 +0300
Change: 2009-07-27 20:52:23.932517304 +0300

-- 
Felipe Contreras
