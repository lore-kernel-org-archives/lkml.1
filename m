Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbZBKGtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbZBKGtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 01:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbZBKGsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 01:48:52 -0500
Received: from rn-out-0910.google.com ([64.233.170.184]:57969 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbZBKGsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 01:48:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=dZcUJ29lU8zScjT9z4gj8Z2XpqGp8PhNsxMFtvgzmFebdWW6nL/LOrVm0LUsKMFVjy
         Kn4j0kCpaMX8UaGnxBaQ4/ZJPdKR4DuNNnW9M+aQzray8zibIH0R7Mk4zN0bFa2U5krd
         E4hS1Ic/C/TiUQiuyNixX7aRBZcbRJaQbgb1Q=
MIME-Version: 1.0
Date: Wed, 11 Feb 2009 14:48:49 +0800
Message-ID: <2f495dc80902102248j26b21a86saefe1a6f811b75b5@mail.gmail.com>
Subject: Help for implementation system based linux update.
From: Fred Fan <fanyefeng@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All:
       I want to implement a function to provide a system update for
our product. I don't know what is popular approach.
The kernal Image update is easy. The problem is update about rootfs,
because our rootfs has over 100Mbytes.
And the storage is hard disk. I can not use cramfs + configuration or
application partition to implement them.
There are a lot of lib. Maybe, I can try them.
I just get two ways to implement it.
First, we can use two same partitions: active or backup. We can switch
them:we alway update the backup partion
and switch the roles of them.
The last one is the init application will be replaced in a rescue
partion or initrd. After the rootfs is update, it will
perform the tranditional init process.
      But I hope I can complete the update before system reboot.
I have follow the switchroot's work flow in nash source code to try it.
First, I kill all non-kernel processes and remove all filesystem
excepts "/" and "/dev":the trial is manual.
The "/dev" can not be umount, althought I have add force flag in command line.
Next, I mount a small partition which has basic rootfs to /mnt.
And then enter /mnt. Also I do mount with move flag to move /mnt to "/".
At last, I use chroot command to switch "/".
I expect, I can umount the original "/". But fact is it is busy. so it
is can not umount.
Could you give me some suggestion about how to implement the latest method?
Or it is totial wrong. So could you give me some suggestion to
implement system update.
Best Regards.
Fred
