Return-Path: <linux-kernel-owner+w=401wt.eu-S1758736AbYAPDIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736AbYAPDIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 22:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757102AbYAPDIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 22:08:10 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:61624 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875AbYAPDII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 22:08:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=GtBakSP1SGtNQRfzsxoR9xGlpv1D4rlkQ3VwXlCphxInApoU/xdkQjKwJxt51WJtKwdp7L6IbIv5UA79oK5ezk9Nd2eJXW4PIRDkbo56jAI7n0YqlXicDsccgu29vT0mVi7c2tOnNZJskglozS0ek/WMMb8WeGIEwmXUp/ujEw8=
Message-ID: <478D7511.8000607@gmail.com>
Date: Wed, 16 Jan 2008 12:08:01 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org, daniel.ritz-ml@swissonline.ch,
       jeff@garzik.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 3/4] printk: implement merging printk
References: <1200445210549-git-send-email-htejun@gmail.com>	<12004452113770-git-send-email-htejun@gmail.com> <20080115190257.f0546a63.randy.dunlap@oracle.com>
In-Reply-To: <20080115190257.f0546a63.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Wed, 16 Jan 2008 10:00:09 +0900 Tejun Heo wrote:
> 
> 
>> ---
>>  include/linux/kernel.h |   71 ++++++++++++++++
>>  kernel/printk.c        |  215 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 286 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
>> index ade3ac9..f92a4a1 100644
>> --- a/include/linux/kernel.h
>> +++ b/include/linux/kernel.h
>> @@ -175,6 +175,29 @@ extern struct pid *session_of_pgrp(struct pid *pgrp);
>>  extern void dump_thread(struct pt_regs *regs, struct user *dump);
>>  
>>  #ifdef CONFIG_PRINTK
>> +struct mprintk {
>> +	char *		header;
>> +	char *		body;
>> +	char *		cur;
>> +	char *		prv;
>> +	char *		end;
> 
> We aren't very consistent about this, but I think that we would prefer
> 
> 	char		*header;
> 
> etc. there.

That's my preference too.  Dunno why I wrote like the above here.  Will
change.

Thanks.

-- 
tejun
