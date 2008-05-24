Return-Path: <linux-kernel-owner+w=401wt.eu-S1759490AbYEXFqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490AbYEXFqR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 01:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbYEXFqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 01:46:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59964 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbYEXFqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 01:46:08 -0400
Message-ID: <4837AAE2.9090102@zytor.com>
Date: Fri, 23 May 2008 22:42:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Steve French <smfrench@gmail.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: kernel coding style for if ... else which cross #ifdef
References: <524f69650805231211r315be4e4u5890aa0f914bcb4f@mail.gmail.com> <48374D3F.1080502@zytor.com> <20080524054301.GA3773@uranus.ravnborg.org>
In-Reply-To: <20080524054301.GA3773@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>> *However*, the best would really be if we changed Kconfig to emit 
>> configuration constants what were 0/1 instead of undefined/defined. 
>> That way we could do:
>>
>> 	if (CONFIG_SOMETHING && foo) {
>> 		/* ... something ... */
>> 	} else if ((mode & S_IWUGO) == 0) {
>> 		/* ... */
> 
> We could do that - but then it would need another
> name not to clash with all the places where we rely
> on CONFIG_FOO='n' => CONFIG_FOO is not defined.
> 
> We could teach kconfig to emit something like:
> #define KFOO 0   (for the 'n' value)
> And 1 or 2 for the y and m values.
> 

I don't think we want to use "1 or 2"... I suspect we want to use the 
same booleans we currently have.

I would suggest CFG_* instead of CONFIG_* for the new set.

	-hpa

