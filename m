Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbZCXV3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbZCXV3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbZCXV3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:29:00 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:16059 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbZCXV27 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:28:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UUn4i/fwE4ilrjNV1nonzsip5quxBJVkMRu1jkuVk5lpJQc0XNPJA2CqunYs7uiCMx
         KUCVS7XLtiNLBd/FtYHi2p2GXfmyKJnhI3I8ARJ/0sIIY29IPI5kdPEpGk4JwH247muc
         vSnGI/Ij9PxLUJ0KBbmgRoMcOHcc/92t8s8fM=
MIME-Version: 1.0
In-Reply-To: <1237929888.3308.31.camel@localhost.localdomain>
References: <1237929168-15341-7-git-send-email-stoyboyker@gmail.com>
	 <1237929888.3308.31.camel@localhost.localdomain>
Date: Tue, 24 Mar 2009 16:28:57 -0500
Message-ID: <6d291e080903241428n325d7805v6a61653d8d6516ba@mail.gmail.com>
Subject: Re: [PATCH 06/13] [scsi] changed ioctls to unlocked
From: Stoyan Gaydarov <stoyboyker@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 4:24 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Tue, 2009-03-24 at 16:12 -0500, stoyboyker@gmail.com wrote:
>> From: Stoyan Gaydarov <stoyboyker@gmail.com>
>>
>> Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
>> ---
>>  drivers/scsi/osst.c |   12 ++++++++----
>>  1 files changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
>> index 0ea78d9..80e7e98 100644
>> --- a/drivers/scsi/osst.c
>> +++ b/drivers/scsi/osst.c
>> @@ -4856,9 +4856,10 @@ static int os_scsi_tape_close(struct inode * inode, struct file * filp)
>>
>>
>>  /* The ioctl command */
>> -static int osst_ioctl(struct inode * inode,struct file * file,
>> -      unsigned int cmd_in, unsigned long arg)
>> +static long osst_ioctl(struct file * file, unsigned int cmd_in,
>> +     unsigned long arg)
>>  {
>> +     lock_kernel();
>
> What necessitates the kernel locking?  When st was audited, it didn't
> need it; since osst is in many ways a copy of st, I'm surprised it does.
>
> James

The lock was there before, because it is used before calling
osst_ioctl, my patches don't change any functionality. It is meant to
show the maintainers of the code that the lock is there and to allow
them make a decision as to how best to handle the code without the
kernel locking. If it is not needed then the locks can be removed and
the function call can remain under the unlocked_ioctl.

-Stoyan

>
>
>



-- 

-Stoyan
