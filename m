Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbXHBFOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbXHBFOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 01:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbXHBFOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 01:14:30 -0400
Received: from smtp103.plus.mail.mud.yahoo.com ([68.142.206.236]:44428 "HELO
	smtp103.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754426AbXHBFO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 01:14:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=gO8FJ0EN3cJH0r9hvEB/sFycTHt0LSkEdWNUMkn6Jtsja6sFNV0aT0HGraD962lLbl/SNh+D5Q/Z3YxBZIQ1HR+RP0CVLNAA9F4C0mHJp/gxEsuRPwCw8qDx8DJwJLoYKLc/zhp3+W0hreZ/ot8qa0/bVUqU60DvYO+nj1usweM=  ;
X-YMail-OSG: vkIBou8VM1mUR69mITiayWi6CA5GjqplN70mP2aMd7EpyPBVyFTdybrHeeAZDD1PxHJUUCH9mQ--
Date: Thu, 2 Aug 2007 07:13:23 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Xudong Guan <xudong.guan@gmail.com>, linux-kernel@vger.kernel.org,
       Chuck Ebbert <cebbert@redhat.com>, michal.k.k.piotrowski@gmail.com
Subject: Re: 2.6.23-rc1: no setup signature found... SOLVED!
Message-ID: <20070802051323.GA4152@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070729085059.GA10758@gollum.tnic> <20070729092402.GA2272@xguan-laptop> <20070729103706.GA16780@gollum.tnic> <46AC9B28.6060906@zytor.com> <20070729191528.GA5166@gollum.tnic> <46ADF02F.7010800@zytor.com> <20070730185359.GA4290@gollum.tnic> <46AE4E29.7060402@zytor.com> <20070801043835.GA4676@gollum.tnic> <46B09A57.8000403@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46B09A57.8000403@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 10:36:07AM -0400, H. Peter Anvin wrote:
> Borislav Petkov wrote:
>> 	Breakpoint 4, 0x00040200 in ?? ()
>> 	1: x/i ($cs << 4) + $eip  0x40300:      lea    (%si),%dx
>> 	(gdb) c
>> 	Continuing.
>> if i do delete here, it loads the second stage of grub and continues to 
>> load the
>> kernel. Is there another way to land at the jmp instruction instead of 
>> poking
>> blindly, maybe disassemble something parts of the initial code. \me 
>> reading
>> grub-docs...
>
> If you do "delete" without a breakpoint number, you're deleting all 
> breakpoints.  I just experimented with grub, and it looks like it should 
> break at 0x90200, so just set that breakpoint and none of the others.
>
> 	-hpa

Hi,

now this is one of those cases where one tries to shoot a small fly with a
nuclear missile. The first assumption that something was wrong with the kernel
setup code was wrong and here's how i know:

The problem with my version of grub not hitting the breakpoint 0x90200 made me
think that something might be messed up in the grub part of the boot sequence.
Thus, i did the qemu simulation again and noticed on the initial boot screen of
grub it saying "Grub version 0.91." However, you remember from a different post
that the version of grub i have is the latest to be found in debian unstable,
0.97-29, so i thought that something has to be wrong with it and especially with all
those grub stages binaries, in my case in /boot/grub, which grub-install setups.
Checking their timestamps revealed that the files are from 2004 so i thought,
well, these are OLD! :) After refreshing the grub installation and replacing
the stages-binaries with the fresh ones, the kernel booted just fine :), here:

[boris@gollum:07:02:07:~:9994)->  uname -a
Linux gollum 2.6.22-4fd06960f120e02e9abc802a09f9511c400042a5-12 #12 PREEMPT Thu Jul 26 18:08:34 CEST 2007 i686 GNU/Linux

so i guess the problem was with the ancient parts of a grub installation i had
lying around which weren't replaced by the apt-get update process and somehow
messed up newer grub versions. Anyway, in the end one still learns a lot while at it.

Thanks for your help.

-- 
Regards/Gruﬂ,
    Boris.
