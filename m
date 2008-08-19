Return-Path: <linux-kernel-owner+w=401wt.eu-S1758750AbYHSULq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750AbYHSULq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 16:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbYHSULi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 16:11:38 -0400
Received: from internal.actusa.net ([208.83.100.16]:60245 "EHLO
	internal.actusa.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbYHSULi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 16:11:38 -0400
Message-ID: <48AB28EF.40608@actusa.net>
Date: Tue, 19 Aug 2008 13:11:27 -0700
From: Stuart Sheldon <stu@actusa.net>
Organization: ACTUSA
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: "make prepare" in 2.6.26.2 not behaving?
References: <48AA4107.9090009@actusa.net> <20080819195228.GB6774@uranus.ravnborg.org>
In-Reply-To: <20080819195228.GB6774@uranus.ravnborg.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Sam Ravnborg wrote:
> On Mon, Aug 18, 2008 at 08:41:59PM -0700, Stuart Sheldon wrote:
>> Hey all, think I found a little bug...
>>
>> I recently was attempting to build 3rd party modules on a 2.6.26.2 
>> source tree after a "make clean" was run on the kernel source tree.
>>
>> In the past I would run "make oldconfig prepare scripts" and then build 
>> and install the 3rd party module. All would work as expected.
>>
>> And all started well with the 2.6.26.2 tree. The module built without 
>> error, but when I went to load it, it responded back with a version 
>> error on the console, and the dmesg was: "no symbol version for 
>> struct_module".
>>
>> If I rebuild the entire kernel and modules in the source tree and then 
>> build the 3rd party module again, It builds and loads without issue.
>>
>> I'm hoping this is a bug, as I use the prepare method of setting up 
>> source trees a lot. It saves me hours of time on my server farm.
> 
> If you have MODULE_VERSIONING enabled then you need to build
> the kernel - "make prepare" is in that case not enough.
> 
> Ig you have module.symvers around then that will do it.
> 
> 	Sam
> 

So the patch to delete the module.symvers from the tree exposed a 
mistake in my config? Makes since. Just to clarify, I want 
CONFIG_MODVERSIONS=n in my .config to use prepare? The help on the 
setting seems to imply that turning it on makes the kernel less picky 
about modules, but I guess I don't get it...

Will change that setting and test.

Thanks!

Stu

-- 
Randomly Generated Fortune Tag:
Many pages make a thick book.
