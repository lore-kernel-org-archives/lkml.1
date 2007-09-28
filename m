Return-Path: <linux-kernel-owner+w=401wt.eu-S1759482AbXI1J5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482AbXI1J5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 05:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756836AbXI1J5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 05:57:16 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:4225 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746AbXI1J5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 05:57:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=HBC7+ICkE9ySbrMmiGEynb+aKQ+7qy1WFLZv97V/F/ucGpdX3zBaizOKFQ8PL+R+Ac46K92S3pdHD2p3xBKnUp7x5SmV0VzWatkqJeXB284iUqJGOcMVpKTOfQi3EqBq6rKk/GLMRWnUaaGfdjEpSnlV82PCsi0Eep2hJ54yk7o=
Message-ID: <46FCCF94.9060400@gmail.com>
Date: Fri, 28 Sep 2007 02:55:32 -0700
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Paul Rolland <rol@as2917.net>
CC: David Newall <david@davidnewall.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>, rol@witbe.net
Subject: Re: 2.6.23-rc7 - _random_ IRQ23 : nobody cared
References: <20070924083336.7a08fd61@tux.DEF.witbe.net>	<46F7C933.4080003@davidnewall.com>	<20070925090057.5778aa2a@tux.DEF.witbe.net>	<46FAFF7A.5070208@gmail.com> <20070927080551.424e90b9@tux.DEF.witbe.net>
In-Reply-To: <20070927080551.424e90b9@tux.DEF.witbe.net>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Rolland wrote:
>> Can you change driver load order such that the driver for the modem is
>> loaded first?
> 
> As I said, it's not possible, because :
>  - the modem driver is an out-kernel one, so I have to wait the end of the
>    boot process so that it can be loaded,
>  - libata on IRQ23 is the one taking care of my disks, and I suspect it 
>    quite hard to install a modem driver before having the disk driver
>    installed.

You can do both by...

1. Build the modem driver into the kernel.  char drivers are linked in
before ATA ones, so it will attach first.

2. Using a custom initrd with emergency shell.  initrd is loaded by BIOS
so no driver is involved.  I don't actually know how to do this tho.

3. Put in an extra disk controller and boot from it with both drivers
compiled as module.

-- 
tejun
