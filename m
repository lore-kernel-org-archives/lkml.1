Return-Path: <linux-kernel-owner+w=401wt.eu-S1753585AbZGWOsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbZGWOsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbZGWOsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:48:14 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49252 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbZGWOsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:48:13 -0400
Message-ID: <3b45d0f54f0f9c96727e4f9d07b97008.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <1248357948.24021.692.camel@nimitz>
References: <20090722175345.7154C2F2@kernel>
    <20090723104450.e0d421ca.kamezawa.hiroyu@jp.fujitsu.com>
    <1248357948.24021.692.camel@nimitz>
Date: Thu, 23 Jul 2009 23:48:11 +0900 (JST)
Subject: Re: [RFC][PATCH] flexible array implementation v3
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Dave Hansen" <dave@linux.vnet.ibm.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       vda.linux@googlemail.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, menage@google.com,
       akpm@linux-foundation.org
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Thu, 2009-07-23 at 10:44 +0900, KAMEZAWA Hiroyuki wrote:

>> The caller can't know whether
>>  - there are no entry or
>>  - NULL(0) is stored at the array.
>>
>> Then, he has to check gotten value is valid or not by himself.
>
> I think you may be reading this bit wrong.  Either that, or I badly
> miscoded it. :)  The flex_array_get() code should returns NULL in cases
> of error or the *address* of the data element.  It will actually return
> an address pointing into the second-level page.
>
> NULL's two meaning here are:
> 1. No element was ever put() here and thus there's no data page
> 2. Your index was out of bounds
>
> (1) is a little fuzzy here.  It of course doesn't absolutely guarantee
> that no put() was done since we just use the data page's existence to
> tell.  This is certainly no worse than a normal C array would be,
> though.
>
ok, maybe not necessary to handle.


>> Can't we return -ENOENT here(especially when prealloc() is called) ?
>> But ah, anyway, all-zero elements in allocated array exists ;(
>> and the user can get value from an entry never be put.
>>
>> If we can fill the first 4bytes of _unused_ index by some magic code
>> like this
>> #define FLEX_ARRAY_UNUSED_MAGIC		(0xa5a5a5a5)
>> (if maintaining bitmap/status of usage is nonsense)
>> and flex_array_get() can return -ENOENT, the users will feel easy.
>>
>> Overprotection ;) ?
>
> I intentionally didn't use kzalloc() for the data pages.  I figured that
> users will either initialize it themselves or pass in __GFP_ZERO.  I've
> added a comment to clarify this.
>

sorry for noise.
I just felt that this code expects users know all they really do.
As said, seems nice :) thank you.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


