Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbYIYSdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbYIYSdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 14:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbYIYSdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 14:33:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41112 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbYIYSde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 14:33:34 -0400
Message-ID: <48DBD96F.6090309@zytor.com>
Date: Thu, 25 Sep 2008 11:33:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 -tip 0/4] x86: signal handler improvement
References: <48DBD396.5020103@ct.jp.nec.com> <48DBD519.6030204@zytor.com> <48DBD8A6.8060900@ct.jp.nec.com>
In-Reply-To: <48DBD8A6.8060900@ct.jp.nec.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiroshi Shimamoto wrote:
>>>
>> This is a gcc failure, and should be reported to the gcc people.
> 
> Does this gcc failure mean unnecessary storing into stack?
> 

Yes, it should be able to process this in a register, instead of storing 
to the stack and then merging later.

It's possible it's trying to do that to hide latency, but that's clearly 
a lose in this case.

I'd hate to obfuscate the code, and I'd *really* hate to obfuscate the 
code to work around gcc brokenness, and then not even bothering to tell 
the gcc folks.

	-hpa
