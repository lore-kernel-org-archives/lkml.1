Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab0BFEZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 23:25:19 -0500
Received: from mail-iw0-f185.google.com ([209.85.223.185]:53148 "EHLO
	mail-iw0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab0BFEZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 23:25:16 -0500
X-Greylist: delayed 493 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Feb 2010 23:25:16 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=oLprMpF13KJkxj2zAehMvirAGLq77zo/MvlcA+MUq8kcv0ngdxCozZ9MfTXj5SHwZz
         0MhhlotA7CmgMBUThpPUjufsOth1fXMJ9Fp+CDVVN87R5aEEGKha9ikAmvlPnKRhe5c5
         2xWB2X6H4uIPmayIMoPFr+Dik9zX+zL0YkRyI=
Date: Sat, 6 Feb 2010 12:19:26 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: 2.6.32.8-stable review : kernel crashed asap
Message-ID: <20100206041926.GA4529@hack>
References: <201002042129.41462.toralf.foerster@gmx.de> <201002051622.02980.toralf.foerster@gmx.de> <20100205155701.GC9690@hack> <201002051730.39578.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201002051730.39578.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 05, 2010 at 05:30:39PM +0100, Toralf Förster wrote:
>
>Américo Wang wrote at 16:57:01
>> On Fri, Feb 05, 2010 at 04:22:02PM +0100, Toralf Förster wrote:
>> >Américo Wang wrote at 16:10:21
>> >
>> >> On Thu, Feb 04, 2010 at 09:29:41PM +0100, Toralf Förster wrote:
>> >> >Immediately during boot it crashed w/ the attached config - no lines
>> >> > within syslog  to post.
>> >>
>> >> What error messages did you see on your screen?
>> >
>> >I attached a screen shot.
>> 
>> Thanks! It's better that if you can capture these info via netconsole
>> or something like that, so that you copy and paste them into email.
>I know - but I'm at home where I've only this ThinkPad ...
>
>> Hmm, it seems that a null pointer deref happened in
>> net/ipv4/devinet.c::inetdev_init(), so Cc'ing netdev guys....
>> 
>> Could you please run the command:
>> 
>>   addr2line -e your_2.6.32.8_vmlinux 0xc11fea28
>> 
>> to check in which line we dereferenced a null pointer?
>
>Here's the information :
>
>n22 /usr/src/linux-2.6.32.8 # addr2line -e vmlinux 0xc11fea28
>devinet.c:0
>

Hmm, thanks, we already found the problem, I think the patch here:

http://patchwork.kernel.org/patch/77357/

should be able to fix this problem.

Thanks for reporting!

-- 
Live like a child, think like the god.
 
