Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbYKANmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbYKANmy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 09:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbYKANmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 09:42:47 -0400
Received: from rtr.ca ([76.10.145.34]:35652 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbYKANmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 09:42:47 -0400
Message-ID: <490C5CFD.6000703@rtr.ca>
Date: Sat, 01 Nov 2008 09:43:25 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Sarangi_Santosh@emc.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: ioctl (HDIO_GETGEO) on partition
References: <A68C75D82BABF64AB13A6AC1875BF275052D707A@CORPUSMX10B.corp.emc.com> <490C5C64.2060609@rtr.ca>
In-Reply-To: <490C5C64.2060609@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Sarangi_Santosh@emc.com wrote:
..
>>   if ((sts = ioctl(fd, HDIO_GETGEO, &hd_geometry_rec)) < 0) ------->
>> ioctl((HDIO_GETGEO)  is failing for device partition (/dev/emcpowerg1)
>>     {
>>       close(fd);
>>       return OS_SYSTEM_CALL_FAILED;
>>     }
..

And while we're at it, that code above REALLY wants
a perror(p_ppdevname) call just before the close(fd) line.
That way, when it fails, you'll find out *why* it fails,
making bugs like this much easier to figure out.

.. 
> The code should try HDIO_GETGEO_BIG before falling back to HDIO_GETGEO.
> But neither will work for LARGE drives (>= 2TB) on 32-bit systems,
> so the code really should try sysfs for this info before using the ioctls.
> 
> Sample code to do this correctly is in the geom.c file of recent hdparm
> source code packages from sourceforge.
