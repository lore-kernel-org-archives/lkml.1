Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbZGUKRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbZGUKRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754802AbZGUKRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:17:24 -0400
Received: from bizon.gios.gov.pl ([195.187.34.71]:44969 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634AbZGUKRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:17:24 -0400
Date: Tue, 21 Jul 2009 12:16:05 +0200 (CEST)
From: Krzysztof Oledzki <olel@ans.pl>
X-X-Sender: ole@bizon.gios.gov.pl
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       lwn@lwn.net
Subject: Re: Linux 2.6.27.27
In-Reply-To: <alpine.LNX.1.10.0907210831210.29729@bizon.gios.gov.pl>
Message-ID: <alpine.LNX.1.10.0907211154480.29729@bizon.gios.gov.pl>
References: <20090720040655.GA11940@kroah.com> <4A645A45.9060509@ans.pl> <20090720151008.GC10015@suse.de> <alpine.LFD.2.01.0907200848530.13838@localhost.localdomain> <alpine.LNX.1.10.0907202341580.29729@bizon.gios.gov.pl> <alpine.LFD.2.01.0907201504470.19335@localhost.localdomain>
 <alpine.LNX.1.10.0907210831210.29729@bizon.gios.gov.pl>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1144830174-1490931129-1248171366=:29729"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1144830174-1490931129-1248171366=:29729
Content-Type: TEXT/PLAIN; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT



On Tue, 21 Jul 2009, Krzysztof Oledzki wrote:

>
>
> On Mon, 20 Jul 2009, Linus Torvalds wrote:
>
>> 
>> 
>> On Mon, 20 Jul 2009, Krzysztof Oledzki wrote:
>>> 
>>> No problem. Please let me know what should I do to help tracking this 
>>> issue.
>> 
>> Can you build two kernels: one with -fwrapv, and one with
>> -fno-strict-overflow, and then verify that
>> 
>> - they are otherwise identical (ie exact same source code, same compiler
>>   etc)
>> 
>> - verify that yes, the -fwrapv kernel works, the other does not. Just to
>>   avoid the confusion that obviously exists with Debian/sid binutils
>>   upgrades that _also_ happens result in nonbootable kernels.
>> 
>> - upload the 'vmlinux' images somewhere (I'm not sure what the limits for
>>   binary attachments are at the kernel bugzilla, but that would be the
>>   logical place)
>> 
>> In fact, it would be nice to have a third "identical" kernel build, except
>> with neither -fwrapv/-fno-strict-overflow.
>
> OK. Right now I'm building the three kernels you asked for 
> (fwrapv/fno-strict-overflow/none). I'll test them and upload vmlinux images.

OK, there are three kernels, exactly as you requested:

http://noc.axelspringer.pl/no-strict-overflow-vs-wrapv/vmlinux-fno-strict-overflow.bz2 (Hangs)
http://noc.axelspringer.pl/no-strict-overflow-vs-wrapv/vmlinux-fwrapv.bz2 (OK)
http://noc.axelspringer.pl/no-strict-overflow-vs-wrapv/vmlinux-fnone.bz2 (OK)

# grep -A1 "can't wrap" linux-2.6.27.27-*/Makefile
linux-2.6.27.27-fno-strict-overflow/Makefile:# disable invalid "can't wrap" optimzations for signed / pointers
linux-2.6.27.27-fno-strict-overflow/Makefile-KBUILD_CFLAGS      += $(call cc-option,-fno-strict-overflow)
--
linux-2.6.27.27-fwrapv/Makefile:# disable invalid "can't wrap" optimzations for signed / pointers
linux-2.6.27.27-fwrapv/Makefile-KBUILD_CFLAGS   += $(call cc-option,-fwrapv)
--
linux-2.6.27.27-fnone/Makefile:# disable invalid "can't wrap" optimzations for signed / pointers
linux-2.6.27.27-fnone/Makefile-#KBUILD_CFLAGS   += $(call cc-option,-fno-strict-overflow)

Plwase note the third one has the KBUILD_CFLAGS commented.

Kernels are identical and are compiled from the same config, on the same 
server with gcc-4.2.4, binutils-2.19. There is no ccache installed and the 
kernels are not patched with any additonal patches - just vanilla 
linux-2.6.27.27.

Screenshot from the hanging kernel (-fno-strict-overflow):
  http://noc.axelspringer.pl/no-strict-overflow-vs-wrapv/2.6.27.27-hang.png

Dmesg from a bootable kernel:
  http://noc.axelspringer.pl/no-strict-overflow-vs-wrapv/dmesg

Best regards,

 				Krzysztof Olêdzki
---1144830174-1490931129-1248171366=:29729--
