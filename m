Return-Path: <linux-kernel-owner+w=401wt.eu-S1761630AbXERTzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761630AbXERTzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 15:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755591AbXERTzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 15:55:11 -0400
Received: from smtp2-g19.free.fr ([212.27.42.28]:53389 "EHLO smtp2-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357AbXERTzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 15:55:10 -0400
Message-ID: <464E049C.9050006@free.fr>
Date: Fri, 18 May 2007 21:55:08 +0200
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070217 Iceape/1.1.1 (Debian-1.1.1-2)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ubi: kill homegrown endian macros
References: <20070517143200.GA30850@lst.de>	 <1179413443.3642.49.camel@sauron> <20070517145653.GA968@lst.de>	 <1179414590.3642.69.camel@sauron>	 <20070517102931.6bbbad1a.akpm@linux-foundation.org>	 <pan.2007.05.17.20.30.30@free.fr> <1179455959.2859.527.camel@shinybook.infradead.org>
In-Reply-To: <1179455959.2859.527.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Thu, 2007-05-17 at 20:30 +0000, Matthieu CASTET wrote:
>> On Thu, 17 May 2007 10:29:31 -0700, Andrew Morton wrote:
>>
>>> On Thu, 17 May 2007 18:09:50 +0300 Artem Bityutskiy
> When I tested this on ARM, the output for je32_to_cpu et al was fine.
> For _other_ structures where I'd used __attribute__((packed)) to be
> safe, gcc would emit code to handle unaligned loads. But not in the
> simple case where the struct has only one member.
I don't think it is true.

When porting some summary stuff to bootloader, I hit some unaligned 
access problem :
in summary.c:405 there is a
switch (je16_to_cpu(((struct jffs2_sum_unknown_flash *)sp)->nodetype)) {
and
struct jffs2_sum_unknown_flash
{
     jint16_t nodetype;  /* node type */
};

note that sp isn't aligned to a 32 bits boundary (it can be anything and 
depend for example of the size of the dirent name).

if gcc doesn't emit code to handle unaligned loads in this case, there 
is unaligned access.

When compiling my code for arm, I use a gcc-4.1.1 with a bug and it 
break. With another compiler (last gcc from codesourcery) it worked 
(because gcc emit load it bit per bit).


> 
> Are you suggesting that this has changed since I did my testing?
> 
Which version of gcc did you try ?

Matthieu
