Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbXEIUw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbXEIUw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 16:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbXEIUwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 16:52:19 -0400
Received: from cmx2.usace.army.mil ([140.194.245.34]:17888 "EHLO
	cmx2.usace.army.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbXEIUwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 16:52:18 -0400
Message-ID: <46423477.2080509@bellsouth.net>
Date: Wed, 09 May 2007 15:52:07 -0500
From: Jay Cliburn <jacliburn@bellsouth.net>
Reply-To: jacliburn@bellsouth.net
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Chuck Ebbert <cebbert@redhat.com>, Tejun Heo <htejun@gmail.com>,
       Greg K-H <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Mat=ED=ADas_?= =?ISO-8859-1?Q?Alejandro_Torres?= 
	<torresmat@gmail.com>
Subject: Re: [PATCH] pci-quirks: disable MSI on RS400-200 and RS480, take
 #2
References: <4641BD26.1020501@gmail.com> <4641EAA5.4030409@redhat.com> <4641EDDC.1020102@gmail.com> <4641EF46.2090506@redhat.com> <46421FCA.7010807@garzik.org>
In-Reply-To: <46421FCA.7010807@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 May 2007 20:52:13.0107 (UTC) FILETIME=[EB625030:01C7927B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Chuck Ebbert wrote:
>> Tejun Heo wrote:
>>>> FWIW several distros have turned off MSI by default and added
>>>> a "pci=msi" option to enable it.
>>> Yeah, it seem to cause a lot of problems on certain chips but I think
>>> the correct path is to add PCI quirks for those.  Most MSI problems I've
>>> seen are on these ATI chips.  Do you happen to know any other?
>>
>> We had devices that didn't do MSI right, e.g. forcedeth and others I
>> can't recall now.
> 
> AFAIK that's a broken diagnosis.   It's the system, not the device, that 
> is problematic.
> 

In the case of the Attansic L1 ethernet driver, here's what we see:

chipset			kernel arch	MSI functionality
===============		===========	=================
Intel 945G/ICH7		x86_64		yes
Intel 945G/ICH7		i386		yes
Via K8T890		x86_64		yes
Via K8T890		i386		no

I still don't know why, but we get a flood of APIC errors after starting the 
atl1 driver on a Via K8T890 board (Asus M2V, for example) under a 32-bit kernel, 
and *only* under a 32-bit kernel.

http://lkml.org/lkml/2007/4/8/68

Supporting files and such at ftp://ftp.hogchain.net/pub/linux/m2v/apic-problem

Any hints heartily welcomed...

Jay

