Return-Path: <linux-kernel-owner+w=401wt.eu-S1756431AbZCOAl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431AbZCOAl3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 20:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbZCOAlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 20:41:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54952 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbZCOAlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 20:41:20 -0400
Message-ID: <49BC4DB6.9070403@zytor.com>
Date: Sat, 14 Mar 2009 17:37:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Latest brk patchset
References: <49BC413B.5020104@zytor.com> <49BC4CAC.202@goop.org>
In-Reply-To: <49BC4CAC.202@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>>
>> It really doesn't make much sense to me, and is more than a bit
>> confusing given the symbols.
> 
> Mostly because I knew that the bss would get mapped into the appropriate
> phdr segment correctly, but I wasn't sure that another bss-like section
> would be.

It will; in fact if they are adjacent then ld will typically merge the
PHDRs.

> Also because historically the brk segment was just an
> extension of the executable's bss, and its more or less the same too.

An extension of, yes, but not a part of.

> Is there any real benefit in putting it into another section?

Well, the semantics are different; the .bss section is zeroed while the
brk isn't, and the brk symbols don't necessarily point to the data
associated with those particular symbols, unlike (of course) the bss.

It's not a big issue, obviously, it just seems cleaner to me that way.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

