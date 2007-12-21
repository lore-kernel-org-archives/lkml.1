Return-Path: <linux-kernel-owner+w=401wt.eu-S1762629AbXLUAQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762629AbXLUAQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 19:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbXLUAQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 19:16:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:53692 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbXLUAQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 19:16:20 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Trying to convert old modules to newer kernels
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Linux kernel <linux-kernel@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Fri, 21 Dec 2007 01:16:09 +0100
References: <9CdyE-1A6-7@gated-at.bofh.it> <9CdIw-1Op-29@gated-at.bofh.it> <9Cebz-2sz-29@gated-at.bofh.it> <9Cvcw-5mu-15@gated-at.bofh.it> <9CwhY-76J-11@gated-at.bofh.it> <9Cyk3-1Zc-29@gated-at.bofh.it> <9CB8a-6zV-13@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1J5VYf-0004go-9q@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+bkKXDkyyxXnSjpADBoMsVCtGxSEkH1WJRW/l
 I1ONGtnIZxdMU0iVW61VSQgvRy4+FXmpXikQ9+aC7CoS89AwBd
 O+A00Gx6BY8y/ySzbuHZw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-os (Dick Johnson) <linux-os@analogic.com> wrote:
> On Thu, 20 Dec 2007, Sam Ravnborg wrote:

>>> It never gets to the printk(). You were right about the
>>> compilation. Somebody changed the kernel to compile with
>>> parameter passing in REGISTERS! This means that EVERYTHING
>>> needs to be compiled the same way, 'C' calling conventions
>>> were not good enough!
>>
>> How did you build the module. It reads like you failed to use
>> kbuild to build your module which is why you did not pass
>> correct options to gcc - correct?
>>
>> If you did not use kbuild - why not?
>> Is there anything missing you need?

> I need to get rid of -mregparm=3 on gcc's command line. It
> is completely incompatible with the standard calling conventions
> used in all our assembly-language files in our drivers. We make
> very high-speed number-crunching drivers that munge high-speed
> data into images. We need to do that in assembly as we have
> always done.

According to my quick googling, "__attribute__((regparm,0))" is what you need.

