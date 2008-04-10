Return-Path: <linux-kernel-owner+w=401wt.eu-S1757440AbYDJQ5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbYDJQ5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 12:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbYDJQ44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 12:56:56 -0400
Received: from homer.mvista.com ([63.81.120.155]:21617 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755413AbYDJQ44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 12:56:56 -0400
Message-ID: <47FE46AC.5000901@ru.mvista.com>
Date: Thu, 10 Apr 2008 20:56:12 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
Cc: linuxppc-dev@ozlabs.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, jgarzik@pobox.com, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 6/13] devres: implement managed iomap interface
References: <11684073371547-git-send-email-htejun@gmail.com>	<47FA4FD2.8060808@ru.mvista.com> <47FB85CB.2070506@gmail.com> <47FB8751.3040301@ru.mvista.com>
In-Reply-To: <47FB8751.3040301@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>>>    Those functions are going to break on 32-bit platforms with 
>>> extended physical address (well, that's starting with Pentiums which 
>>> had 36-bit PAE :-) AND devices mapped beyond 4 GB (e.g. PowerPC 
>>> 44x).  You should have used resource_size_t for the 'offset' 
>>> parameter. As this most probably means that libata is broken on such 
>>> platforms, I'm going to submit a patch...

>    It's broken with drivers using MMIO, I meant to say.

    Oops, I meant PCI drivers here, at least for the time being. And it looks 
like that was a false alarm. :-]

>> Yeah, right please go ahead.  But I wonder whether any BIOS was 
>> actually crazy enough to map mmio region above 4G on 32bit machine.

>    This is a *hardware* mapping on some non-x86 platforms (like PPC 44x 
> or MIPS Alchemy). The arch/ppc/ and arch/mips/ kernels have special 
> hooks called from ioremap() which help create an illusion that the PCI 
> memory space on such platforms (not only it) is mapped below 4 GB; 
> arch/powerpc/ kernel doesn't do this anymore -- hence this newly 
> encountered issue.

    I thought that pcim_iomap() used devm_ioremap() or something -- which of 
course turned to be wrong. devm_ioremap() alone is yet safe since there are no 
users for it amongst PPC 44x platform device drivers...

MBR, Sergei
