Return-Path: <linux-kernel-owner+w=401wt.eu-S1751814AbYITQjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbYITQjT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 12:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbYITQiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 12:38:54 -0400
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:36542 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbYITQix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 12:38:53 -0400
Message-ID: <48D5271B.7010109@weinigel.se>
Date: Sat, 20 Sep 2008 18:38:51 +0200
From: Christer Weinigel <christer@weinigel.se>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>, Russ Dill <russ.dill@gmail.com>,
       Eric Miao <eric.y.miao@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org
Subject: Re: kernel.h: add ARRAY_AND_SIZE() macro to complement	ARRAY_SIZE().
References: <20080918132447.516309749@fluff.org.uk> <20080918150624.GA3421@x200.localdomain> <f17812d70809181138xb0e4d4bs8a6361bb038b5a6e@mail.gmail.com> <20080919065426.GA7222@lenovo> <f17812d70809190022u6c862ae8j43b1c1a942e22497@mail.gmail.com> <f9d2a5e10809190828g54a824b9od1ade53c96a518c8@mail.gmail.com> <20080919175544.GA3228@x200.localdomain> <48D4F519.2080509@weinigel.se> <20080920134543.GA7354@localhost> <48D50883.6040700@weinigel.se> <20080920144504.GB7354@localhost>
In-Reply-To: <20080920144504.GB7354@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> [Christer Weinigel - Sat, Sep 20, 2008 at 04:28:19PM +0200]
> ...
>> In my opinion, making platform_add_devices into a magic macro is  
>> actually worse, since the same construct (array, ARRAY_SIZE(array)) is  
>> used in many places, so one would have to do the same thing over and  
>> over again for every function.  In that case it's better to have to  
>> learn one macro once, and the ALL_CAPITALS should make it obvious that  
>> it is a macro.

> Well, can't agree with you :) It's my _presonal_ opinion.
> You could define it as
> 
> static inline int platform_add_devices_array(struct platform_device **devs)
> {
> 	return platform_add_devices(devs, ARRAY_SIZE(devs));
> }

Won't work.  You would have to use a macro.  The above would turn into:

      platform_add_devices(devs, 1);

or would if the __must_be_array check didn't catch it.

   /Christer
