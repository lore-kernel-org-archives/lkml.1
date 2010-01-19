Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047Ab0ASMuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab0ASMuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 07:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898Ab0ASMub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 07:50:31 -0500
Received: from proxima.lp0.eu ([81.2.80.65]:53632 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab0ASMu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 07:50:29 -0500
Message-ID: <dad314e12c5750b1b5d70c3ea3c6f6134b8fa0f3@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
In-Reply-To: <4B5578A5.50705@gmail.com>
References: <4B54CDE5.3070100@simon.arlott.org.uk>
    <4B5578A5.50705@gmail.com>
Date: Tue, 19 Jan 2010 12:50:28 -0000
Subject: Re: [PATCH] xt_TCPMSS: SYN packets are allowed to contain data
From: "Simon Arlott" <simon@fire.lp0.eu>
To: "William Allen Simpson" <william.allen.simpson@gmail.com>
Cc: "netdev" <netdev@vger.kernel.org>, "Patrick McHardy" <kaber@trash.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, January 19, 2010 09:17, William Allen Simpson wrote:
> Simon Arlott wrote:
>> The check for data only needs to apply where the packet length
>> could be increased by adding the MSS option. (The MSS option
>> itself applies to the sender's maximum receive size which is
>> not relevant to any data in its own packet.)
>>
>> This moves the check for (header size != packet size) to after
>> attempting to modify an existing MSS option. Another check is
>> needed before looking through the header to ensure it doesn't
>> claim to be larger than the packet size.
>>
>
> 2) There certainly *can* be data on SYN.  That code is already in
> 2.6.33....

I could change the comment too, but the same logic applies when
there is data and no MSS option - the packet can't be increased
in size if it would then exceed 576 bytes and/or the destination
MTU.

If it's possible to know that the packet can have an additional
option added without exceeding MTU then this could be changed.
The data part would need to be moved to make space at the end of
the header.

-- 
Simon Arlott
