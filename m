Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbZLKPUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbZLKPUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758394AbZLKPUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:20:07 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:44029 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758291AbZLKPUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:20:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iN1zFMTccO5PdJ6kS2rlCNWINAfoKEyOwRibUCr2QuPuQ8mLtCBWkZFRiYfxGs7Zsz
         TDEe1X16yKQPSlDV/xNZ3ss8Gz/zigzBhFgs98Vf4AVdgww72aYwndtaDa9vWYPcf1VJ
         W91OAvigZTVqbL5qKm0moYtKo8TkJe73vr0e0=
Date: Fri, 11 Dec 2009 23:21:15 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Cedric Le Goater <clg@fr.ibm.com>
Subject: Re: [Patch] ipc: HARD_MSGMAX should be higher not lower on 64bit
Message-ID: <20091211152115.GA2414@hack>
References: <20091211061316.3969.99500.sendpatchset@localhost.localdomain> <20091211144433.GA23731@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211144433.GA23731@us.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Hi, I am the same person.)

On Fri, Dec 11, 2009 at 08:44:33AM -0600, Serge E. Hallyn wrote:
>Quoting Amerigo Wang (amwang@redhat.com):
>> It looks weird that we have HARD_MSGMAX lower on 64bit than on 32bit,
>> since usually 64bit machines have more memory than 32bit machines.
>
>It does look like this may have been an accident.
>

OK.

>> Making it higher on 64bit seems reasonable, and keep the original
>> number on 32bit.
>> 
>> Cc: Serge E. Hallyn <serue@us.ibm.com>
>> Cc: Cedric Le Goater <clg@fr.ibm.com>
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>> 
>> ---
>> diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
>> index e408722..07baa38 100644
>> --- a/include/linux/ipc_namespace.h
>> +++ b/include/linux/ipc_namespace.h
>> @@ -87,7 +87,7 @@ extern int mq_init_ns(struct ipc_namespace *ns);
>>  /* default values */
>>  #define DFLT_QUEUESMAX 256     /* max number of message queues */
>>  #define DFLT_MSGMAX    10      /* max number of messages in each queue */
>> -#define HARD_MSGMAX    (131072/sizeof(void *))
>> +#define HARD_MSGMAX    (32768*sizeof(void *)/4)
>
>why /4 ?  You're now making it much smaller for 32-bit than it
>used to be?
>

Yes?

Before this patch, it is 131072/sizeof(void*) = 32768;
after this patch, it is 32768*sizeof(void*)/4 = 32768 too.
Both on 32bit, of course.

Am I missing something?


-- 
Live like a child, think like the god.
 
