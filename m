Return-Path: <linux-kernel-owner+w=401wt.eu-S1753707AbZLBMlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbZLBMlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 07:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbZLBMlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 07:41:19 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:58935 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbZLBMlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 07:41:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=UqSpvZMEcdonM8NK+fQZ1BaeuLB185eXxxuru9EJm/3owWP7ZcnrVCEAGvICWBOeX6
         pj0Xs7nSyQfRtJWZP2qhyzrhM2wlQ+871IaGD0WJColYTDl4SK3voTHitVqdPGRrhBp+
         Nglgdh2jBx+YgVBU25xOmnoEAnSWECMEqudVc=
Message-ID: <4B166032.8050005@gmail.com>
Date: Wed, 02 Dec 2009 14:40:18 +0200
From: Lior Dotan <liodot@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091201)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Linux 2.6.32-rc8 - T500 fails to suspend to RAM
References: <4B151FE2.3090807@gmail.com> <200912012246.58383.rjw@sisk.pl>
In-Reply-To: <200912012246.58383.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Tuesday 01 December 2009, Lior Dotan wrote:
>   
>> Hi,
>>
>> Ever since I've upgraded to rc8, my T500 fails to suspend to RAM for the
>> second time. Suspending for the first time works ok but when I resume and
>> later try to suspend again the screen gets blank and the moon LED blinks
>> forever. rc6 & rc7 as well as 2.6.31 worked great with out a problem.
>>     
>
> Well, I don't see any particular change that might cause the symptoms you
> describe between -rc7 and -rc8.  If this is 100% reproducible, I guess
> bisecting is the only option at the moment.
>   
I tried bisecting it, not sure if it's any good but this is what I got:

ldot@topaz ~/linux/linux-2.6 $ git bisect bad
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[1456edbb1476db735715ddcc7ac306de587024eb] kconfig: Make zconf.y work 
with current bison
ldot@topaz ~/linux/linux-2.6 $ git bisect log
git bisect start
# bad: [648f4e3e50c4793d9dbf9a09afa193631f76fa26] Linux 2.6.32-rc8
git bisect bad 648f4e3e50c4793d9dbf9a09afa193631f76fa26
# good: [156171c71a0dc4bce12b4408bb1591f8fe32dc1a] Linux 2.6.32-rc7
git bisect good 156171c71a0dc4bce12b4408bb1591f8fe32dc1a
# bad: [b6b24c73d56a166a829318a1f06803ff9b54857b] spi: error status 
should be negative
git bisect bad b6b24c73d56a166a829318a1f06803ff9b54857b
# bad: [82abc2a97a4a3c7635c40e6dff571816062ec506] Merge branch 
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2
git bisect bad 82abc2a97a4a3c7635c40e6dff571816062ec506
# good: [24dfb2b5867df24ba03b6c4418312e23b1300aa8] Merge branch 
'upstream' of git://ftp.linux-mips.org/pub/scm/upstream-linus
git bisect good 24dfb2b5867df24ba03b6c4418312e23b1300aa8
# bad: [e8e63cbf9a339c972eeb5ccf8777c8067bdfd869] oss: Mark loadhex 
static in hex2hex.c
git bisect bad e8e63cbf9a339c972eeb5ccf8777c8067bdfd869
# bad: [ad0cd62ab632afe9b562b5f09343c21e1521505d] 
arch/alpha/boot/tools/objstrip.c: Mark "usage" static
git bisect bad ad0cd62ab632afe9b562b5f09343c21e1521505d
# bad: [65166571800af0f63f21e5576d7db12d2bf73790] kconfig: Mark various 
internal functions static
git bisect bad 65166571800af0f63f21e5576d7db12d2bf73790

Cheers,
Lior

