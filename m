Return-Path: <linux-kernel-owner+w=401wt.eu-S1762146AbZDHFow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762146AbZDHFow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760058AbZDHFol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:44:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35380 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759868AbZDHFok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:44:40 -0400
Message-ID: <49DC39EE.1070606@redhat.com>
Date: Wed, 08 Apr 2009 08:45:18 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] do not keep interrupt window closed by sti in real mode
References: <1239161017-7398-1-git-send-email-glommer@redhat.com> <49DC24C2.7000608@zytor.com>
In-Reply-To: <49DC24C2.7000608@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Glauber Costa wrote:
>   
>> While in real mode, sti does not block interrupts from the subsequent
>> instruction. This is stated at Intel SDM Volume 2b, page 4-432
>>     
>
> I don't see how you're getting that idea from the STI documentation --
> and I am quite sure that that is not the case.  Quite on the contrary.
> The only differences between protected mode and real mode has to do with
> the handling of VIF when CPL=3 (this rather naturally falls out if one
> considers CPL=0 in real mode).
>   

I'm guessing the problem is due to the second instruction.  We don't 
clear the 'blocked by interrupt shadow' flag when we emulate, which 
extends interrupt shadow by one more instruction.  If the instruction 
sequence is 'sti hlt' we end in an inconsistent state.



-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

