Return-Path: <linux-kernel-owner+w=401wt.eu-S932455AbXFEUqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455AbXFEUqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 16:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765510AbXFEUp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 16:45:57 -0400
Received: from mail.tmr.com ([64.65.253.246]:40183 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761044AbXFEUp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 16:45:56 -0400
Message-ID: <4665C9FA.5060207@tmr.com>
Date: Tue, 05 Jun 2007 16:39:22 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Segher Boessenkool <segher@kernel.crashing.org>
CC: David Woodhouse <dwmw2@infradead.org>, Kyle Moffett <mrmacman_g4@mac.com>,
       John Stoffel <john@stoffel.org>, Willy Tarreau <w@1wt.eu>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, CaT <cat@zip.com.au>,
       Ondrej Zajicek <santiago@crfreenet.org>, linux-kernel@vger.kernel.org,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Thomas Gleixner <tglx@linutronix.de>, Dongjun Shin <djshin90@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Arnd Bergmann <arnd@arndb.de>,
       Albert Cahalan <acahalan@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org,
       Artem Bityutskiy <dedekind@infradead.org>,
       Sam Ravnborg <sam@ravnborg.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@lazybastard.org>,
       Pavel Machek <pavel@ucw.cz>, Ulisses Furquim <ulissesf@gmail.com>,
       akpm@osdl.org, David Weinehall <tao@acc.umu.se>
Subject: Re: [Patch 04/18] include/linux/logfs.h
References: <20070603183845.GA8952@lazybastard.org> <20070603184205.GE8952@lazybastard.org> <200706032342.27252.arnd@arndb.de> <20070604091245.GF14823@lazybastard.org> <1180964303.25232.358.camel@pmac.infradead.org> <18f622d94e9273fe6c93ef091fcec87c@kernel.crashing.org>
In-Reply-To: <18f622d94e9273fe6c93ef091fcec87c@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Segher Boessenkool wrote:
>> It would be better if GCC had a 'nopadding' attribute which gave us what
>> we need without the _extra_ implications about alignment.
>
> That's impossible; removing the padding from a struct
> _will_ make accesses to its members unaligned (think
> about arrays of that struct).
And many platforms happily support unaligned CPU access in hardware at a 
price in performance, while other support it in software at great cost 
in performance. None of that maps into impossible, Some i/o hardware may 
not support at all and require some bounce buffering, at cost in memory 
and CPU.

None of that equates with impossible. It is readily argued that it could 
mean inadvisable on some architectures, slow as government assistance 
and ugly as the north end of a south-bound hedgehog, but it's not 
impossible.

Do NOT take this to mean I think it would be a good thing in a Linux 
kernel, or that it should be added to gcc, but in some use like embedded 
applications where memory use is an important cost driver, people are 
probably doing it already by hand to pack struct arrays into minimal 
bytes. It's neither impossible nor totally useless.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

