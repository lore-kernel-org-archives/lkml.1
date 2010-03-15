Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936186Ab0COMJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 08:09:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:32976 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934452Ab0COMJc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 08:09:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pmaUnhCvhI0HlsBBLO5VnawSZ1g12Zler7yZRJa7e2iTRb4pKtGaADSvFZRq9mKcgO
         Slee0jvQxt+7oizn74Wdv01N4Cf/6mv7aedVpXSK1GAQHDzHneUTS55FCr1uTNznszn2
         C5QuPUrO1DyiBPjdJIPO5nzBrDHKKOttIDKEY=
MIME-Version: 1.0
In-Reply-To: <4B9D0D1E.3010404@gmail.com>
References: <38b2ab8a1003130056u4b025839i556a797ccad894de@mail.gmail.com>
	 <4B9D0D1E.3010404@gmail.com>
Date: Mon, 15 Mar 2010 13:09:30 +0100
Message-ID: <38b2ab8a1003150509i4a9e7e1dqce2bfb11557d403d@mail.gmail.com>
Subject: Re: sys_umount() returns EBUSY when doing: sh -c "mount /dev/sdc1 
	/mnt; umount /mnt"
From: Francis Moreau <francis.moro@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 14, 2010 at 5:21 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
> On 03/13/2010 02:56 AM, Francis Moreau wrote:
>>
>> Hello
>>
>> I've some shell scripts which try to find out the filesystem hosted by
>> a block device.
>>
>> They basically do this:
>>
>>     mount /dev/sdc1 /mnt
>>     fs=$(stat -f -c %T $mount_point)
>>     umount /mnt
>>
>> It happens to work but since an unknown upgrade (kernel, libs or tools
>> upgrade), umount(8) returns -EBUSY.
>>
>> I found that it's actually the sys_umount() which return -EBUSY.
>>
>> So the question, is this expected or is this a regression ?
>>
>> If it's expected then which operation should I add between the
>> mount(8) and umount(8) to make the mount operation completely finish
>> (inside the kernel) so the next umount won't return -EBUSY ?
>
> If no other process were involved I would say it's likely a bug. However, my
> guess is that some other process (HAL, something in GNOME, etc.) detects the
> mount and decides to start accessing the drive. Then when you immediately
> try to unmount, it fails because it's busy. I suspect if you try this in
> single-user mode with no unnecessary processes running you won't see this.
>

You're right, I don't see this anymore if I'm booting in a single user mode.

So I need to find out how to wait until these other processes stop
accessing the drive.

Thanks
-- 
Francis
