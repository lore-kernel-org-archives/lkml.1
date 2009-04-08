Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbZDHIVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbZDHIVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 04:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763290AbZDHIPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 04:15:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52221 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763296AbZDHIPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 04:15:37 -0400
Message-ID: <49DC5D4D.9060801@redhat.com>
Date: Wed, 08 Apr 2009 11:16:13 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] do not keep interrupt window closed by sti in real mode
References: <1239161017-7398-1-git-send-email-glommer@redhat.com> <49DC24C2.7000608@zytor.com> <49DC39EE.1070606@redhat.com> <49DC436C.2050309@zytor.com>
In-Reply-To: <49DC436C.2050309@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Avi Kivity wrote:
>   
>> I'm guessing the problem is due to the second instruction.  We don't
>> clear the 'blocked by interrupt shadow' flag when we emulate, which
>> extends interrupt shadow by one more instruction.  If the instruction
>> sequence is 'sti hlt' we end in an inconsistent state.
>>
>>     
>
> Ah, and since we're in real mode, we have to emulate everything (at
> least on some hardware), right?  

Well, not everything.  We use vm86 mode in the guest to emulate real 
mode.  Of course that doesn't support all instructions, so we emulate 
these.  Unfortunately it also doesn't support big real mode.

> So we really do need to clear the
> interrupt shadow bit in the interpreter... I don't see a way around that.
>   

Yes.

> Otherwise not just STI but MOV SS shadows will break, and in real mode
> MOV SS shadow is crucial.
>   

'mov ss' executes natively.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

