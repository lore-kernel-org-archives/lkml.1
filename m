Return-Path: <linux-kernel-owner+w=401wt.eu-S1760306AbXFBLjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306AbXFBLjo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 07:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758962AbXFBLja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 07:39:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:35892 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757767AbXFBLj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 07:39:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Lhw7gWZX4DRKX2/yQnGFkLFOxEdJME+VjghAgwnwSdTwgq0BHQKMVziAGpKLhsb290OlbJqqLAdykxtEmayZCjyrRVTXv6pQ/mZrwSFKgn2BgD6mEPTqBWRgyDKtOFQvSUEK9OaarSEvHR1IXverxcY/B+D4K8UXCmKYjFAGq1k=
Message-ID: <46613C53.8010205@gmail.com>
Date: Sat, 02 Jun 2007 18:45:55 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: David Greaves <david@dgreaves.com>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       IDE Linux <linux-ide@vger.kernel.org>, ballen@gravity.phys.uwm.edu
Subject: Re: 2.6.22-rc3 hibernate(?) disables SMART on ide
References: <46609290.5030701@dgreaves.com>
In-Reply-To: <46609290.5030701@dgreaves.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Greaves wrote:
> I have 2 ide disks. If I enable SMART and hibernate/suspend2disk, SMART is
> disabled when I resume.
> 
> Same as in 2.6.21.1
> 
> cu:~# smartctl -son /dev/hda
> smartctl version 5.36 [i686-pc-linux-gnu] Copyright (C) 2002-6 Bruce Allen
> Home page is http://smartmontools.sourceforge.net/
> 
> === START OF ENABLE/DISABLE COMMANDS SECTION ===
> SMART Enabled.
> 
> cu:~# /usr/net/bin/hibernate
> [poweron resume here]
> cu:~# smartctl -a /dev/hda
> smartctl version 5.36 [i686-pc-linux-gnu] Copyright (C) 2002-6 Bruce Allen
> Home page is http://smartmontools.sourceforge.net/
> 
> === START OF INFORMATION SECTION ===
> Model Family:     Seagate Barracuda ATA II family
> Device Model:     ST320420A
> Serial Number:    3CL04RKY
> Firmware Version: 3.21
> User Capacity:    20,404,101,120 bytes
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   4
> ATA Standard is:  Exact ATA specification draft version not indicated
> Local Time is:    Fri Jun  1 22:37:15 2007 BST
> SMART support is: Available - device has SMART capability.
> SMART support is: Disabled
> 
> SMART Disabled. Use option -s with argument 'on' to enable it.

According to the ATA standard, the device (drive) itself is responsible
for preserving SMART enabled status over power cycles.  It seems your
drive doesn't wanna do that.  I don't think mangling with SMART setup in
the kernel is wise thing to do.  Bruce, any ideas?  Maybe hook smartd
such that it gets suspend/resume events?

Thanks.

-- 
tejun

