Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbYDUKAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbYDUKAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620AbYDUKAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:00:07 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:62594 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbYDUKAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:00:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Z04BoZ+oxmCys9jlbJ/YRkaZSMYCL3xtU2KfUC3G+4lhUW+bWSOZN4SIxo9YMgh/ASzlKgRr4j5D15/EsmCkWP7evlRvh0VDTVzBtLL1Tc4accskVwNso9+EiR8aSiVjO8EVZP7vF/LPtAQFWTsDGT9Jw83sAE+NxpgXdT9yBa4=
Message-ID: <480C6597.1000701@gmail.com>
Date: Mon, 21 Apr 2008 11:59:51 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: fault in __d_lookup [Was: 2.6.25-mm1]
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org> <480C50EC.2090803@gmail.com> <20080421090610.GO27459@ZenIV.linux.org.uk> <480C6064.10801@gmail.com> <20080421094515.GR27459@ZenIV.linux.org.uk>
In-Reply-To: <20080421094515.GR27459@ZenIV.linux.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2008 11:45 AM, Al Viro wrote:
> On Mon, Apr 21, 2008 at 11:37:40AM +0200, Jiri Slaby wrote:
>> On 04/21/2008 11:06 AM, Al Viro wrote:
>>> On Mon, Apr 21, 2008 at 10:31:40AM +0200, Jiri Slaby wrote:
>>>
>>>        hlist_for_each_entry_rcu(dentry, node, head, d_hash) {
>>>                struct qstr *qstr;
>>>
>>>                if (dentry->d_name.hash != hash)
>>>                        continue;
>>>
>>> walking into node == (struct hlist_node *)0x00f0000000000000...
>> Yup, true, In the last oops I stuck on memcmp few lines below.
>>
>> BTW. it's 100% reproducible after it happens once, but fixable by reboot. 
>> Any tests I should run (memtest, some printks sticked anywhere)?
> 
> Well, if list has such turd in it, you'll certainly hit it every time
> you walk that list, so 100% reproducible is not surprising.
> 
> How well is it reproducible from fresh boot?

Few days with suspend/resume cycles. This one was booted 12 hours ago, one 
suspend/resume. Will keep an eye on it and keep you informed.
