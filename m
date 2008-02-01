Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbYBASHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbYBASHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 13:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYBASHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 13:07:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59637 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbYBASHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 13:07:11 -0500
Message-ID: <47A35FBB.5030003@zytor.com>
Date: Fri, 01 Feb 2008 10:06:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: sparse errors from string_32.h
References: <1201846516.23523.87.camel@brick> <20080201105624.GD27178@elte.hu>
In-Reply-To: <20080201105624.GD27178@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
>>  		case 1:
>> -			*(unsigned char *)s = pattern;
>> +			*(unsigned char *)s = pattern & 0xff;
> 
> i've applied your fix - but wouldnt it be cleaner to just cast the 
> pattern variable to unsigned char instead?
> 

Even better, since we're talking about fixed bytes, I suggest writing it as:

	*(u8 *)s = (u8)pattern;

Much more compact and the intent is a little bit more obvious.

	-hpa
