Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbYDHO4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbYDHO4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 10:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbYDHOz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 10:55:56 -0400
Received: from homer.mvista.com ([63.81.120.155]:41643 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752628AbYDHOzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 10:55:55 -0400
Message-ID: <47FB8751.3040301@ru.mvista.com>
Date: Tue, 08 Apr 2008 18:55:13 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
Cc: jgarzik@pobox.com, gregkh@suse.de, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 6/13] devres: implement managed iomap interface
References: <11684073371547-git-send-email-htejun@gmail.com> <47FA4FD2.8060808@ru.mvista.com> <47FB85CB.2070506@gmail.com>
In-Reply-To: <47FB85CB.2070506@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:

>>    A very late comment but nevertheless... :-)

> Better late than never.

    :-)

>>    Those functions are going to break on 32-bit platforms with 
>> extended physical address (well, that's starting with Pentiums which 
>> had 36-bit PAE :-) AND devices mapped beyond 4 GB (e.g. PowerPC 44x).  
>> You should have used resource_size_t for the 'offset' parameter. As 
>> this most probably means that libata is broken on such platforms, I'm 
>> going to submit a patch...

    It's broken with drivers using MMIO, I meant to say.

> Yeah, right please go ahead.  But I wonder whether any BIOS was actually 
> crazy enough to map mmio region above 4G on 32bit machine.

    This is a *hardware* mapping on some non-x86 platforms (like PPC 44x or 
MIPS Alchemy). The arch/ppc/ and arch/mips/ kernels have special hooks called 
from ioremap() which help create an illusion that the PCI memory space on such 
platforms (not only it) is mapped below 4 GB; arch/powerpc/ kernel doesn't do 
this anymore -- hence this newly encountered issue.

WBR, Sergei
