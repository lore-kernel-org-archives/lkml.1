Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbYJQMVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbYJQMVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbYJQMVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:21:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:18794 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbYJQMU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:20:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E5uQtj9Wkl7G/dyzNePBZXaUX2j4zV08P+oIWmAnzqSo1Mz1kLl3EKZsN+ZMmIO689
         sp8Sedr4e/sCEwdE9eIjJBoP3crj67oPb5FEBTUA7ItPC8ansAnPDfF9nNE3p/RFuAx7
         62K42Yl1Wg88Vu2GOwc1SXw+AlFemy4CCo4nE=
Date: Fri, 17 Oct 2008 13:20:32 +0100
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, jdike@addtoit.com, stable@kernel.org
Subject: Re: [Patch] uml: fix one compile error
Message-ID: <20081017122032.GF2951@hack.voiplan.pt>
References: <20081016152626.GD13374@hack.voiplan.pt> <20081016161557.af935f49.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016161557.af935f49.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 04:15:57PM -0700, Andrew Morton wrote:
>On Thu, 16 Oct 2008 16:26:26 +0100
>Am__rico Wang <xiyou.wangcong@gmail.com> wrote:
>
>> 
>> This patch fixed the following compile error:
>> 
>>   CC      arch/um/sys-i386/signal.o
>>   /home/wangcong/Projects/linux-2.6/arch/um/sys-i386/signal.c: In
>> function 'copy_sc_from_user':
>> /home/wangcong/Projects/linux-2.6/arch/um/sys-i386/signal.c:182:
>> warning: dereferencing 'void *' pointer
>> /home/wangcong/Projects/linux-2.6/arch/um/sys-i386/signal.c:182:
>> error: request for member '_fxsr_env' in something not a structure or
>> union
>> 
>> 
>> Signed-off-by: WANG Cong <wangcong@zeuux.org>
>> Cc: jdike@addtoit.com
>> 
>> ---
>> diff --git a/arch/um/sys-i386/signal.c b/arch/um/sys-i386/signal.c
>> index fd0c25a..1296473 100644
>> --- a/arch/um/sys-i386/signal.c
>> +++ b/arch/um/sys-i386/signal.c
>> @@ -179,7 +179,8 @@ static int copy_sc_from_user(struct pt_regs *regs,
>>  	if (have_fpx_regs) {
>>  		struct user_fxsr_struct fpx;
>>  
>> -		err = copy_from_user(&fpx, &sc.fpstate->_fxsr_env[0],
>> +		err = copy_from_user(&fpx,
>> +			&((struct _fpstate __user *)sc.fpstate)->_fxsr_env[0],
>>  				     sizeof(struct user_fxsr_struct));
>>  		if (err)
>>  			return 1;
>
>Which kernel versions are affected by this error? 2.6.27?

I haven't tried a stable version, but I will. :)


-- 
"Sometimes the only way to stay sane is to go a little crazy."

