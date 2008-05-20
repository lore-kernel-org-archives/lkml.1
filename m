Return-Path: <linux-kernel-owner+w=401wt.eu-S932973AbYETQuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973AbYETQuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 12:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759537AbYETQuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 12:50:08 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:42035
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077AbYETQuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 12:50:07 -0400
Message-ID: <4833013D.8020506@qumranet.com>
Date: Tue, 20 May 2008 19:50:05 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make LIST_POISON less deadly
References: <1211125094-32167-1-git-send-email-avi@qumranet.com> <20080520164758.GA8531@elf.ucw.cz>
In-Reply-To: <20080520164758.GA8531@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Sun 2008-05-18 18:38:14, Avi Kivity wrote:
>   
>> The list macros use LIST_POISON1 and LIST_POISON2 as undereferencable
>> pointers in order to trap erronous use of freed list_heads.  Unfortunately
>> userspace can arrange for those pointers to actually be dereferencable,
>> potentially turning an oops to an expolit.
>>
>> To avoid this allow architectures (currently x86_64 only) to override
>> the default values for these pointers with truly-undereferncable values.
>> This is easy on x86_64 as the virtual address space is smaller than
>> the range spanned by pointer values.
>>     
>
> "Security hole unless arch maintainer does _foo_" sounds
> scary. Especially when i386 is hard to fix...
>   

It's a potential security hole.  You need to find a list corruption 
first.  The patch prevents escalation of the oops into a code injection.

i386 is fixable, though it will take more work than x86_64.

-- 
error compiling committee.c: too many arguments to function

