Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbZB0IWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbZB0IWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 03:22:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbZB0IVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 03:21:52 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:35430 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbZB0IVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 03:21:51 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49A7A25A.9050601@s5r6.in-berlin.de>
Date: Fri, 27 Feb 2009 09:20:42 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net, linux-media@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Ben Backx <ben@bbackx.com>, Henrik Kurelid <henrik@kurelid.se>
Subject: Re: [git pull] DVB + ieee1394: firedtv driver
References: <tkrat.847a062a8a488f0d@s5r6.in-berlin.de> <20090226013708.GA16892@elte.hu> <49A6BC72.5050206@s5r6.in-berlin.de> <alpine.LFD.2.00.0902260824470.3111@localhost.localdomain> <20090226170320.GA25475@elte.hu>
In-Reply-To: <20090226170320.GA25475@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> Two choices that I can see:
>>
>>  - do the ieee1394_init() as a fs_initcall(), earlier
>>
>>  - move drivers/ieee1394 linking up to before drivers/media
>>
>> but I suspect that drivers/media wants to be early, in order to do the 
>> _media_ layer initialization early.

The former seems the better choice to me.  Changing the linking order 
would just break the next time around.

>> Does this work?
> 
> yes, i just tested it and your patch fixes the crash:
> 
>  mercury:~> uname -a
>  Linux mercury 2.6.29-rc6-tip-02011-gb62a1ed-dirty #250 SMP Thu 
>  Feb 26 19:00:54 CET 2009 i686 athlon i386 GNU/Linux
>  mercury:~> uptime
>   19:02:51 up 0 min,  1 user,  load average: 3.97, 1.10, 0.37
> 
> Tested-by: Ingo Molnar <mingo@elte.hu>

Thanks guys.  I'm very sorry that this basic issue escaped my attention. 
It's the first time that a 1394 driver lives outside 
drivers/ieee1394/Makefile.

(Also shows that even very long exposure in linux-next does not catch 
runtime issues like this one.)

Stefan Richter
