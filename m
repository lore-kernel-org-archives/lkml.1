Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbYJ2KCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbYJ2KCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 06:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbYJ2KB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 06:01:58 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:12023 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbYJ2KB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 06:01:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=vsiuUY4vf5XRN6TG7/DSBR2JgsSdv5rTnXclUM/SeQ9BwIVRTZP1W3EMvzu4u9UZVk
         jiyel0P7Fz7Otzh7tmcCwHGMOu2MeyBQchgih0LMHHEDMx+yQSpeZpKtmT4B/o5YYORT
         rH6lOBRXHHjmffuouDxrLbclvYz8n5c3cPjwM=
Message-ID: <386072610810290301g564aa303nadb60c06155806be@mail.gmail.com>
Date: Wed, 29 Oct 2008 18:01:56 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Folkert van Heusden" <folkert@vanheusden.com>
Subject: Re: [2.6.26] kobject_add_internal failed for 2:0 with -EEXIST / unable to handle kernel NULL pointer dereference in sysfs_create_link
Cc: "Kay Sievers" <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20081029094041.GO11214@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081028151157.GI11214@vanheusden.com>
	 <ac3eb2510810281607o19266977l4c77d3d3ab4bb849@mail.gmail.com>
	 <20081029094041.GO11214@vanheusden.com>
X-Google-Sender-Auth: 70d3607a8ea4a89a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 5:40 PM, Folkert van Heusden
<folkert@vanheusden.com> wrote:
>> > While running my http://vanheusden.com/pyk/ script (which randomly
>> > inserts and removes modules) I triggered the folllowing oops in a 2.6.26
>> > kernel on an IBM xSeries 260. This oops (in fact no oops at all) did not
>> > get triggered in a 2.6.18 kernel on that system.
>> >
>> > [   42.507375] FDC 0 is a National Semiconductor PC87306
>> > [   42.509057] kobject_add_internal failed for 2:0 with -EEXIST, don't try to register things with the same name in the same directory.
>> > [   42.509291] Pid: 5301, comm: modprobe Not tainted 2.6.26-1-amd64 #1
>> > [   42.509431]
>> > [   42.509433] Call Trace:
>> > [   42.509685]  [<ffffffff8031b031>] kobject_add_internal+0x13f/0x17e
>> > [   42.509823]  [<ffffffff8031b46e>] kobject_add+0x74/0x7c
>> > [   42.509969]  [<ffffffff802e2470>] sysfs_addrm_finish+0x19/0x1ea
>> > [   42.510141]  [<ffffffff802e21b4>] sysfs_find_dirent+0x1b/0x2f
>> > [   42.510331]  [<ffffffff802e2741>] create_dir+0x5a/0x87
>> > [   42.510466]  [<ffffffff8031ae88>] kobject_get+0x12/0x17
>> > [   42.510614]  [<ffffffff80382771>] get_device+0x17/0x20
>> > [   42.510754]  [<ffffffff80382d81>] device_add+0x9b/0x53f
>> > [   42.510915]  [<ffffffff8031acf2>] kobject_init+0x41/0x69
>> > [   42.511374]  [<ffffffff803832d1>] device_create_vargs+0x9a/0xc6
>> > [   42.511519]  [<ffffffff8027d23b>] bdi_register+0x57/0xb4
>>
>> Looks like bdi sees two devices with the same devnum, or didn't
>> cleanup an old entry.
>> What does: ls -l "/sys/class/bdi/" print?
>
> The following:
> folkert@debiantesthw:~$ ls -l /sys/class/bdi/
> total 0
> drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:0
> drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:1
> drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:10
> drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:11
> drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:12
> drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:13
> drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:14
> drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:15
> drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:2
> drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:3
> drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:4
> drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:5
> drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:6
> drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:7
> drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:8
> drwxr-xr-x 3 root root 0 2008-10-28 18:32 1:9
> drwxr-xr-x 3 root root 0 2008-10-28 18:32 2:0
> drwxr-xr-x 3 root root 0 2008-10-28 18:32 2:1
> drwxr-xr-x 3 root root 0 2008-10-28 18:32 254:0
> drwxr-xr-x 3 root root 0 2008-10-28 18:32 254:1
> drwxr-xr-x 3 root root 0 2008-10-28 18:32 254:2
> drwxr-xr-x 3 root root 0 2008-10-28 18:32 254:3
> drwxr-xr-x 3 root root 0 2008-10-28 18:32 254:4
> drwxr-xr-x 3 root root 0 2008-10-28 18:32 254:5
> drwxr-xr-x 3 root root 0 2008-10-28 18:32 3:0
> drwxr-xr-x 3 root root 0 2008-10-29 11:39 7:0
> drwxr-xr-x 3 root root 0 2008-10-29 11:39 7:1
> drwxr-xr-x 3 root root 0 2008-10-29 11:39 7:2
> drwxr-xr-x 3 root root 0 2008-10-29 11:39 7:3
> drwxr-xr-x 3 root root 0 2008-10-29 11:39 7:4
> drwxr-xr-x 3 root root 0 2008-10-29 11:39 7:5
> drwxr-xr-x 3 root root 0 2008-10-29 11:39 7:6
> drwxr-xr-x 3 root root 0 2008-10-29 11:39 7:7
> drwxr-xr-x 3 root root 0 2008-10-28 18:32 8:0
> drwxr-xr-x 3 root root 0 2008-10-28 18:32 default
>
>> How many floppies (or emulated floppies) does this system have?
>
> 1 physical.
>
>

Hi guys,

I found similar issue on Blackfin board and I believe it is a common bug for bdi
http://lkml.org/lkml/2008/10/16/126

But there is no response about this bug, although I am working on it.

-Bryan
