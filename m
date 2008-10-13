Return-Path: <linux-kernel-owner+w=401wt.eu-S1757945AbYJMV2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbYJMV2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 17:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753710AbYJMV2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 17:28:12 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:39715 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbYJMV2L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 17:28:11 -0400
In-Reply-To: <Pine.LNX.4.64.0810131959140.9041@axis700.grange>
References: <20081013040703.GA11059@ime.usp.br> <Pine.LNX.4.64.0810131959140.9041@axis700.grange>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=ISO-8859-1; delsp=yes; format=flowed
Message-Id: <BAFAB2E9-A9E1-443D-9774-459965AF52C1@ime.usp.br>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org
Content-Transfer-Encoding: 8BIT
From: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Subject: Re: [PATCH] powerpc: compile kernel for linkstations optimized for size
Date: Mon, 13 Oct 2008 19:28:02 -0200
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Guennadi.

On 13/10/2008, at 16:03, Guennadi Liakhovetski wrote:

> On Mon, 13 Oct 2008, Rogério Brito wrote:
>
>> From: Rogério Brito <rbrito@ime.usp.br>
>>
>> Since Linkstations and Kuroboxes often have *very* little memory (as
>> they are embedded systems), it is desirable to get their kernels
>> compiled optimized for size.
>>
>> Signed-off-by: Rogério Brito <rbrito@ime.usp.br>
>>
>> ---
>>
>> I have been using kernels optimized for size on my Kurobox (standard)
>> for many different releases and I have experienced no problem with  
>> this
>> option enabled. Thus, this patch.
>
> The comment for this option says: "watch out for broken compilers," if
> this doesn't hold any more, it should be remove, if it still holds, I
> wouldn't turn this on by default, as I don't think we can test all

Pragmatically speaking, -O2 can be broken too (and see the amount of  
ICEs that you can get with newer kernels even compiling with -O2).  
Unless you prove that the compiler is correct and keeps all its  
invariants, then you can rely on this. But, pragmatically speaking  
again, gcc has bugs.

But leaving the mathematical situation aside (Dijkstra would have  
spanked all of us here :)), as I mentioned below the signed off line,  
I have been using -Os and it is working fine. It's serving me quite  
well and with a decent uptime:

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
- - -
lutz:~# uptime
  19:22:53 up 17 days,  5:56,  1 user,  load average: 0.00, 0.00, 0.00
lutz:~# uname -a
Linux lutz 2.6.27-rc6.try02 #8 Fri Sep 26 11:29:55 BRT 2008 ppc GNU/ 
Linux
lutz:~#
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
- - -

And, despite the 0.00 load, I'm streaming music with it via mt-daapd  
and serving cifs mounts.

> possible (cross- or native-) compilers users might want to use. In any
> case this is one of options that users can select themselves, if it  
> suits
> them.

And that is, not to mention, with a very home-brew and quick'n'dirty  
cross-compiled kernel (with a vanilla gcc 4.2.0 taken straight from  
gcc.gnu.org; the same with the kernel: no patches applied).

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org



