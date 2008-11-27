Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbYK0L1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbYK0L1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 06:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbYK0L1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 06:27:15 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:40935 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbYK0L1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 06:27:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nlDscaewoFL0dw4ru/67mJLiTqpf7gfKEI0Hyt93ixGU/jQPJT4DJtmqXuiJDJJ6te
         5o9xd4y4HyNgcteSSAI9Us4FulThmR33cmiJja8FUySA0/9eBmeV3mOOYOoGMXHWivwM
         HkcaSOWegXytoQPmAag0HXNLllaX9qbI+Gm2Y=
Message-ID: <aa79d98a0811270327i28f89148w3fa0f7030ad8cd54@mail.gmail.com>
Date: Thu, 27 Nov 2008 14:27:12 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Alexander van Heukelum" <heukelum@fastmail.fm>
Subject: Re: [PATCH 4/5] x86: ret_from_fork - add CFI proc annotation
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1227780926.25079.1287038929@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1227727024-2281-1-git-send-email-gorcunov@gmail.com>
	 <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com>
	 <cc7949234e3ac0ddb402764be5ed620035f964a6.1227725632.git.gorcunov@gmail.com>
	 <6bc2fd402754cfa5b69a63a529bc065584c5f375.1227725632.git.gorcunov@gmail.com>
	 <39e35cbc79237b162a0720dceaa52a72c7eb1690.1227725632.git.gorcunov@gmail.com>
	 <1227780926.25079.1287038929@webmail.messagingengine.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 1:15 PM, Alexander van Heukelum
<heukelum@fastmail.fm> wrote:
>
> On Wed, 26 Nov 2008 22:17:03 +0300, gorcunov@gmail.com said:
>> From: Cyrill Gorcunov <gorcunov@gmail.com>
>>
>> ret_from_fork is definitly procedure so mark it as that.
>>
>> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
>> ---
>>  arch/x86/kernel/entry_64.S |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
>> index c409f73..a21be86 100644
>> --- a/arch/x86/kernel/entry_64.S
>> +++ b/arch/x86/kernel/entry_64.S
>> @@ -370,6 +370,7 @@ END(save_paranoid)
>>   */
>>  /* rdi:      prev */
>>  ENTRY(ret_from_fork)
>> +     CFI_STARTPROC
>>       DEFAULT_FRAME
>>       push kernel_eflags(%rip)
>>       CFI_ADJUST_CFA_OFFSET 8
>
> This is not needed/wanted. DEFAULT_FRAME includes "CFI_STARTPROC simple"
> already.
>
> Alexander
>
>> 1.6.0.4.603.gbc9c0
>>
> --
>  Alexander van Heukelum
>  heukelum@fastmail.fm
>
> --
> http://www.fastmail.fm - The professional email service
>
>

Indeed, thanks (such an indirect and nested definition sometime confusing)
