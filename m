Return-Path: <linux-kernel-owner+w=401wt.eu-S1756532AbZJSOuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbZJSOuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 10:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756439AbZJSOuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 10:50:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:5035 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436AbZJSOuR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 10:50:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=luNkrgp7pxjJbIu9p8whCt0lk3MI1cmkd4/JW6kkQqFyLXzis0G6cVMh9T98dVGGiP
         pBFsXa1Tg0yqe2Lw++9vAM2Bv0tfKMfJK9Lu+vKDrXXBbn0Opiu1nyU8fvtRku2wkqg0
         QNgP/HBnHGmO2Saz5RQcgM430I0Ic5ciQW4yo=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.0910191610160.8582@wotan.suse.de>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>
	 <1255906474-25091-3-git-send-email-felipe.contreras@gmail.com>
	 <alpine.LSU.2.00.0910191610160.8582@wotan.suse.de>
Date: Mon, 19 Oct 2009 17:50:21 +0300
Message-ID: <94a0d4530910190750j5674ef13m93198b68d305b188@mail.gmail.com>
Subject: Re: [PATCH 2/7] ipc: fix trivial warning
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 5:12 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Mon, 19 Oct 2009, Felipe Contreras wrote:
>
>> Commit a0d092f introduced the following warning:
>> ipc/msg.c: In function ?msgctl_down?:
>> ipc/msg.c:415: warning: ?msqid64? may be used uninitialized in this function
>>
>> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>> ---
>>  ipc/msg.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/ipc/msg.c b/ipc/msg.c
>> index 2ceab7f..085bd58 100644
>> --- a/ipc/msg.c
>> +++ b/ipc/msg.c
>> @@ -412,7 +412,7 @@ static int msgctl_down(struct ipc_namespace *ns, int msqid, int cmd,
>>                      struct msqid_ds __user *buf, int version)
>>  {
>>       struct kern_ipc_perm *ipcp;
>> -     struct msqid64_ds msqid64;
>> +     struct msqid64_ds uninitialized_var(msqid64);
>>       struct msg_queue *msq;
>>       int err;
>
> What gcc are you using? I am not getting any warning at least with gcc
> "(SUSE Linux) 4.3.1 20080507 (prerelease) [gcc-4_3-branch revision
> 135036]"

gcc (GCC) 4.4.1 20090725 (Red Hat 4.4.1-2)

Since I moved to Fedora 11 I get more warnings than other people,
possibly because gcc 4.4.

-- 
Felipe Contreras
