Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbXIOPR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbXIOPR5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 11:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbXIOPRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 11:17:50 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:50973 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbXIOPRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 11:17:49 -0400
Message-ID: <46EBF774.2030306@gmail.com>
Date: Sat, 15 Sep 2007 17:17:08 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Kai Germaschewski <kai@germaschewski.name>,
       Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: Per option CFLAGS?
References: <46EB141A.7090200@gmail.com> <46EB1599.4020806@zytor.com> <46EB198D.2040208@gmail.com> <20070915084754.GO3563@stusta.de>
In-Reply-To: <20070915084754.GO3563@stusta.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2007 10:47 AM, Adrian Bunk wrote:

> On Sat, Sep 15, 2007 at 01:30:21AM +0200, Rene Herman wrote:
>> On 09/15/2007 01:13 AM, H. Peter Anvin wrote:
>>
>>> Rene Herman wrote:
>>>> I have a single file foo.c that I want to generate two (ALSA) modules
>>>> from, snd-foo2000.ko and snd-foo2001.ko, by compiling with either
>>>> FOO2000 or FOO2001 defined.
>>>>
>>>> I can do this, and ALSA does this a few times, by providing dummy
>>>> foo2000.c and foo2001.c files, like:
>>>>
>>>> === foo2000.c
>>>> #define FOO2000
>>>> #include "foo.c"
>>>> ===

[ ... ]

>>> The stub source file is usually considered a good way to do this.
>> Mmm. If I'll have to live with it, I can, but thought I'd ask if there was 
>> some nice build trickery available instead.
> 
> The usual trick is to create _three_ modules:
> 
> Two with the foo2000 and foo2001 specific parts, and a third one with 
> all code used by both.
> 
> Or if foo2000 and foo2001 differ only in small details, create one 
> snd-foo200x module supporting both at the same time.

Thanks for the comment. Yes, first would be massive overkill in this case 
and second somewhat annoying as one of the differences is support for 
different resources (IRQs) among the two versions, whereas I'm checking the 
validity of the passed in values at a time I do not know which version I'm 
looking at yet -- knowing that requires having talked to the hardware.

Can do, but for now it seems like the two seperate modules might be cleaner. 
Can keep things much more straighforward that way by just redefining a bunch 
of #defines.

I'll just do the split version first and if someone really wants me to, I'll 
merge them after all...

Rene

