Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbZC2UIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbZC2UIe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 16:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbZC2UIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 16:08:24 -0400
Received: from main.gmane.org ([80.91.229.2]:57003 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbZC2UIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 16:08:23 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: fastboot/async and initramfs: How am I supposed to know when?devices are finished initializing?
Date: Sun, 29 Mar 2009 21:03:34 +0100
Message-ID: <mp05a6-inv.ln1@woodchuck.wormnet.eu>
References: <49CF9BA1.5030400@archlinux.org> <20090329091148.16a618bf@infradead.org> <49CFA436.5080000@archlinux.org> <ac3eb2510903291036w13dc34cbi97525e6dd9af1da5@mail.gmail.com> <49CFB553.1020800@archlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: woodchuck.wormnet.eu
User-Agent: tin/1.9.3-20080506 ("Dalintober") (UNIX) (Linux/2.6.26-1-sparc64 (sparc64))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Bächler <thomas@archlinux.org> wrote:
> 
> Kay Sievers schrieb:
>> In initramfs, you have to wait until the device shows up, not for a
>> random module to initialize, or a bus to be scanned -- that can never
>> work correctly, it's pure luck, that your logic was always slower than
>> the kernel.
>> 
>> You need a block device -- so you should just wait for the block
>> device, instead of making assumptions about initialization of drivers
>> or buses. :)
> 
> I am planning to do that but there is one problem: Usually, the user 
> specifies a root device, or a device that I want to open with 
> cryptsetup, or anything similar and I can wait until it shows up.
> 
> For lvm however, the user does not specify a specific block device that 
> I can wait for, instead lvm scans all available block devices. Now, how 
> do I know that the block device that contains my physical volume is 
> already there? Maybe I have several hard drives, and several volume 
> groups, so should I now call vgchange -ay again and again until the 
> right volume group shows up?
> 
If the user is specifying the boot device, could you not 'teach' them to 
LABEL the boot device and live off something slightly more fancy (but 
akin to) the following:

----
while true
do
  mount LABEL=root /whatever

  if [ $? -eq 0 ]; then
    break
  fi

  # do some md and lvm magic dance here

  sleep 1
done
----

Your initramfs could do extra steps everytime the loop...erm...loops.

Now of course the downside is LABELing mounted devices, XFS for example, 
is not an easy thing to do... :-/

Cheers

-- 
Alexander Clouter
.sigmonster says: Am I ranting?  I hope so.  My ranting gets raves.

