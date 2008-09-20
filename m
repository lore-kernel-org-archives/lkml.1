Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbYITNFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbYITNFk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 09:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbYITNFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 09:05:32 -0400
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:50062 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbYITNFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 09:05:31 -0400
Message-ID: <48D4F519.2080509@weinigel.se>
Date: Sat, 20 Sep 2008 15:05:29 +0200
From: Christer Weinigel <christer@weinigel.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Russ Dill <russ.dill@gmail.com>, Eric Miao <eric.y.miao@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org
Subject: Re: kernel.h: add ARRAY_AND_SIZE() macro to complement	ARRAY_SIZE().
References: <20080918132447.516309749@fluff.org.uk> <20080918150624.GA3421@x200.localdomain> <f17812d70809181138xb0e4d4bs8a6361bb038b5a6e@mail.gmail.com> <20080919065426.GA7222@lenovo> <f17812d70809190022u6c862ae8j43b1c1a942e22497@mail.gmail.com> <f9d2a5e10809190828g54a824b9od1ade53c96a518c8@mail.gmail.com> <20080919175544.GA3228@x200.localdomain>
In-Reply-To: <20080919175544.GA3228@x200.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Fri, Sep 19, 2008 at 08:28:45AM -0700, Russ Dill wrote:
>> My vote is for ARRAY_AND_SIZE to spread far and wide across the land.
>> ARRAY_SIZE is already very safe, as it has a __must_be_array macro
>> built in. So ARRAY_AND_SIZE is even safer, as it prevents you from
>> mixing up two different arrays. It also reduces line length and makes
>> driver and device (usually platform_device) registration code easier
>> to read.
> 
> It also spreads ARRAY_SIZE misnaming futher.

You still haven't explained what's misnamed about it, nor suggested a 
better name.

> It introduces one more core macro and quite pointless one. I can't
> personally recall a single bug where sizeof() was taken from another
> array.

You haven't written a lot of machine definitions then.  When adding 
platform devices for an embedded platform one has to write a lot of 
boilerplate like this:

     platform_add_devices(n30_devices, ARRAY_SIZE(n30_devices));

and it is much too easy to copy paste that line and miss one of the 
references.

> It creates interesting confusion point: ARRAY_AND_SIZE is about array
> and it's size. What ARRAY_SIZE is about then?

ARRAY_AND_SIZE -> (An) array and (its) size

ARRAY_SIZE -> (The) array size

Sure, you could write ARRAY_AND_ITS_SIZE, but would that really make 
anyone happy?  Cobol went out of fashion a long time ago.

   /Christer

