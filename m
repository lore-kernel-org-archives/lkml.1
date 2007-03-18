Return-Path: <linux-kernel-owner+w=401wt.eu-S932189AbXCRK3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbXCRK3J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 06:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932201AbXCRK3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 06:29:09 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:7417 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189AbXCRK3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 06:29:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=BwKhvArpVdTWoACb9xd2CLoRbUwwsVu4Oz54fJThW/P7Yqjdldn/Ft+ShXBn/L7SGG1UNZ0SYN4HQIBijDjjIs3XuTeXN1x7J9exaHcsRZWvYYkx8VuEb4hzA7eBelhYDuj4UQ752vblX/9br9uu1qoJt5jhCOZfT9jUSG3LXpg=
Message-ID: <45FD1469.8020803@gmail.com>
Date: Sun, 18 Mar 2007 19:28:57 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: rol@as2917.net
CC: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Jeff Garzik'" <jeff@garzik.org>, "'Alan Cox'" <alan@redhat.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, "'LKML'" <linux-kernel@vger.kernel.org>,
       "'Eric D. Mudama'" <edmudama@gmail.com>
Subject: Re: [git patches] libata fixes
References: <00e001c76945$7f2157e0$2101a8c0@donald>
In-Reply-To: <00e001c76945$7f2157e0$2101a8c0@donald>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Rolland wrote:
> Hello,
> 
>> Can you put the harddisk under high load and see what happens?  How
>> often do those errors occur?  Care to post full dmesg?
> 
> I started again a stock 2.6.21-rc4, and ran that :
> while (/bin/true); do tar jxf linux-2.6.19.1.tar.bz2; rm -rf linux-2.6.19.1;
> echo -n "."; done      
> 
> After several minutes (I waited more than 300 loops to be completed), and
> a lot of errors, I finally managed to see :
> Mar 18 10:32:47 riri kernel: ata1.00: NCQ disabled due to excessive errors
> 
> Mar 18 10:23:26 riri kernel:          res 40/00:58:53:6e:31/00:00:0d:00:00/40
> Emask 0x2 (HSM violation)
> Mar 18 10:25:07 riri kernel:          res 40/00:d8:db:b0:2e/00:00:0d:00:00/40
> Emask 0x2 (HSM violation)
> Mar 18 10:32:42 riri kernel:          res 40/00:c0:7b:6a:2a/00:00:0d:00:00/40
> Em
> ask 0x2 (HSM violation)
> Mar 18 10:32:47 riri kernel: ata1.00: NCQ disabled due to excessive errors
> Mar 18 10:32:47 riri kernel:          res 40/00:b8:63:0d:2d/00:00:0d:00:00/40
> Em
> ask 0x2 (HSM violation)
> 
> Is this what you were expecting ?

Yeap, more than three HSM violations in ten minutes.  That's the
criteria for turning off NCQ.  Good to see it working.  It look like a
lot because libata reports all active commands (can't help as on HSM
failure, there's no way to determine which caused it) and the SCSI
prints revalidation messages, but it's still only three errors.

Thanks for verifying that.  I wanted to verify it works in the field as
expected.

-- 
tejun
