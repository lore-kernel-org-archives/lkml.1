Return-Path: <linux-kernel-owner+w=401wt.eu-S1752210AbXJUMjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbXJUMjJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 08:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbXJUMi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 08:38:58 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:42099 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbXJUMi5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 08:38:57 -0400
Message-ID: <471B483D.90305@bull.net>
Date: Sun, 21 Oct 2007 14:38:21 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: IceDove 1.5.0.12 (X11/20070606)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 00/11] KVM updates for Linux 2.6.24-rc review
References: <1192964892617-git-send-email-avi@qumranet.com>	<471B340C.5010800@qumranet.com> <471B3DD3.3080107@bull.net> <471B40E4.4060204@qumranet.com>
In-Reply-To: <471B40E4.4060204@qumranet.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 21/10/2007 14:45:28,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 21/10/2007 14:45:30,
	Serialize complete at 21/10/2007 14:45:30
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity a écrit :
> Laurent Vivier wrote:
>> Avi Kivity a écrit :
>>> Avi Kivity wrote:
>>>> The following patches fix fallout from the main 2.6.24 KVM merge.  An
>>>> exception is the movnti emulation patch, which adds support for Linux
>>>> 2.6.16 guests.
>>>>
>>>> The patches can be found in kvm.git in the branch kvm-updates-2.6.24.
>>>> There is also a branch kvm-updates-2.6.25 which will form the basis of
>>>> the next merge window submission.
>>>>
>>>> Please review the patches and let me know if something is wrong or if
>>>> a patch is missing.
>>>>
>>>>   
>>>
>>> Laurent, I believe the following patch (in kvm-updates-2.6.25) needs 
>>> to go into 2.6.24 as well.  Can you comment on this?
>> What kind of comment do you want ?
> 
> Well, whether it needs to go into .24.
> 
>> What are the requirements to go in 2.6.24 instead of 2.6.25 ?
>>
>> Is a bug correction enough ? :-P
>>
> 
> It has to fix something real-life, in a real guest.
> 
>> This patch correct a bad behavior of x86_emulate_insn() in case of 
>> error with a REP prefix.
>>
>> This patch is needed because, without it, when REP prefix is used with 
>> an instruction failing for some reasons (like IO or page fault) we 
>> don't restore all modified registers (like RSI and RDI), but only ECX 
>> and EIP, so when we re-enter in x86_emulate_insn() we modify again an 
>> already modified value. Moreover, this patch manages correctly the 
>> case where the instruction fails in writeback().
>>
> 
> Okay, I guess it is needed.  Can you backport it to the branch?  It's 
> very different from kvm-updates-2.6.24...
> 

Well, in fact it is not needed in 2.6.24, because this patch correct a bad 
behavior introduced by commit 57f4e446ebca4aad5c11364baf8477c8cfcb16a4 (which is 
not in kvm-update-2.6.24):

KVM: Call x86_decode_insn() only when needed

Move emulate_ctxt to kvm_vcpu to keep emulate context when we exit from kvm
module. Call x86_decode_insn() only when needed. Modify x86_emulate_insn() to
not modify the context if it must be re-entered.

So, in fact, the answer is (after correctly understanding the question): no, 
this patch is not needed in kvm-update-2.6.24.

Regards,
Laurent
-- 
---------------- Laurent.Vivier@bull.net  -----------------
"Given enough eyeballs, all bugs are shallow" E. S. Raymond

