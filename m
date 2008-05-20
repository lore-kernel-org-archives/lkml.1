Return-Path: <linux-kernel-owner+w=401wt.eu-S933140AbYETPSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140AbYETPSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756397AbYETPSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:18:03 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:35022
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbYETPSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:18:01 -0400
Message-ID: <4832EBA7.2040007@qumranet.com>
Date: Tue, 20 May 2008 18:17:59 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Make LIST_POISON less deadly (v3)
References: <1211283565-30671-1-git-send-email-avi@qumranet.com> <87fxsdgg6f.fsf@basil.nowhere.org>
In-Reply-To: <87fxsdgg6f.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Avi Kivity <avi@qumranet.com> writes:
>   
>>  
>> +config ILLEGAL_POINTER_VALUE
>> +       hex
>> +       default 0 if X86_32
>> +       default 0xffffc10000000000 if X86_64
>>     
>
> Don't make it exactly 0xffffc10000000000 but 0xffffc10000000000 + 0x1000000
> or so, otherwise list_entry() users which subtract offsets would still
> end up in user space and there might be actually something in there
> by default.
>   

The poison code adds a large offset (>1MB) so we're safe here.

-- 
error compiling committee.c: too many arguments to function

