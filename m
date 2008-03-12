Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869AbYCLOWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbYCLOWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 10:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbYCLOWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 10:22:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44440 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbYCLOWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 10:22:17 -0400
Message-ID: <47D7E6DB.6030709@zytor.com>
Date: Wed, 12 Mar 2008 15:21:15 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Mark early_printk as asmlinkage
References: <1205330034-28828-1-git-send-email-jirislaby@gmail.com> <1205330034-28828-2-git-send-email-jirislaby@gmail.com> <47D7E2FB.2020801@zytor.com> <47D7E392.3080807@gmail.com>
In-Reply-To: <47D7E392.3080807@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 03/12/2008 03:04 PM, H. Peter Anvin wrote:
>> Jiri Slaby wrote:
>>> It's not explicitly marked as asmlinkage, but invoked from x86_32
>>> startup code with parameters on stack.
>>>
>>> No other architectures define early_printk and none of them are affected
>>> by this change, since defines asmlinkage as empty token.
>>
>> NAK.
>>
>> The regparm ABI for x86-32 uses parameters on the stack when the 
>> function is varadic (as it is here), so this is unnecessary.
> 
> Makes sense. Why is printk marked as asmlinkage?

Hm.  Don't know if it's historical, stylistic (anything called from 
assembly should have "asmlinkage"), or just based on a misunderstanding 
of the regparm ABI.

	-hpa
