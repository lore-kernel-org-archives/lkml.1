Return-Path: <linux-kernel-owner+w=401wt.eu-S1754276AbXIQMrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbXIQMrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 08:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbXIQMrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 08:47:05 -0400
Received: from p-mail1.rd.francetelecom.com ([195.101.245.15]:2844 "EHLO
	p-mail1.rd.francetelecom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753137AbXIQMrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 08:47:04 -0400
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Sep 2007 08:47:03 EDT
Message-ID: <46EE68AC.3090809@Free.fr>
Date: Mon, 17 Sep 2007 13:44:44 +0200
From: Eric Valette <Eric.Valette@Free.fr>
Reply-To: Eric.Valette@Free.fr
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: =?ISO-8859-15?Q?=22=3F=3F=3F=3F=3F=3F=3F_=3C=5C=22Paul_Rolland_?=
	 =?ISO-8859-15?Q?=5C=22=22?= <rol@witbe.net>,
       Rob Hussey <robjhussey@gmail.com>, flamingice@sourmilk.net,
       andreamrl@tiscali.it, linux-kernel@vger.kernel.org
Subject: Re: rtl8187 driver in 2.6.23-rc6-git5: kernel panic if not used as
 a module. Works as a module.
References: <46EBE70C.2040201@free.fr>	<46EBEBD2.7060502@free.fr>	 <6b8cef970709150928h25a7093md5f86d2bdcf677cc@mail.gmail.com>	 <46EC24B6.2030709@free.fr> <20070915185153.08490a9b@tux.DEF.witbe.net>	 <46EC2BBB.1030506@free.fr> <1190022515.3934.4.camel@localhost>
In-Reply-To: <1190022515.3934.4.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Sep 2007 11:46:56.0931 (UTC) FILETIME=[73234730:01C7F920]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg wrote:
> On Sa, 2007-09-15 at 21:00 +0200, Eric Valette wrote:
>
>   
>> I came to this conclusion too. But I would have preferred to have
>> #define subsys_exit(fn)			modules_exit(fn)
>>
>> in the case of a module and nop in the non module case...
>>     
>
> module_exit is a no-op anyway in the non-modular case, it's never
> called, so what's the point?
>   
That I would have prefered to see subsys_exit in front of
subsys_initcall instead of module_exit because
     1) it made me wonder if it still works in the module case
     2) If you see the comment in init.h (/* Don't use these in modules,
but some people do... */), you should not use it in module. The comment
is, at least misleading, because for code that can be used as module or
directly embedded in some cases you are indeed forced to use it (did a
grep and found a lot)
     3) Non symetrical code frequently points to errors or bad design.
YMMV :-)
     4) If someone someday find something to do when shutting down
(hotrestart, fault tolerance,  or something equivalent), we would have a
place to hook. C++ has destructors called after main and before __exit...

NB : This has nothing to do with the proposed patch that is definitively
correct given current init.h.

Personally, I would certainly add:

#define subsys_exit(fn) in init.h

But would rate it myself as a cosmetic change as it *only* makes the code more obvious to read :-)

-- eric

