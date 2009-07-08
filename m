Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbZGHCCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbZGHCCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 22:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755961AbZGHCCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 22:02:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:48661 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755900AbZGHCCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 22:02:15 -0400
Message-ID: <4A53FE21.40009@kernel.org>
Date: Wed, 08 Jul 2009 11:02:09 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Figo.zhang" <figo1802@gmail.com>
CC: Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vmalloc.c: fix double error checking
References: <1246983201.2597.13.camel@myhost>  <4A53E602.6030505@kernel.org> <1247013611.2597.22.camel@myhost>
In-Reply-To: <1247013611.2597.22.camel@myhost>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Jul 2009 02:02:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Figo.zhang wrote:
> On Wed, 2009-07-08 at 09:19 +0900, Tejun Heo wrote:
>> Figo.zhang wrote:
>>> it is no need for double error checking.
>>>
>>> Signed-off-by: Figo.zhang <figo1802@gmail.com>
>>> -		err = vmap_pud_range(pgd, addr, next, prot, pages, &nr);
>>> -		if (err)
>>> -			break;
>>> +		if (vmap_pud_range(pgd, addr, next, prot, pages, &nr))
>>> +			return -ENOMEM;
>> Wouldn't it be better to keep the error return value?
> 
> see the vmap_pud_range(), if suceed return 0, if error return "-ENOMEM",
> so it had better use clearly logic if error directly return "-EOMEM",
> avoid double checking.

Yeah, I saw that but I still think it would be (minutely) better to
just pass through the error value.  It isn't exclusive with double
error checking, just do err = vmap_pud_range(); if (err) return err;

Thanks.

-- 
tejun
