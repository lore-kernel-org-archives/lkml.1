Return-Path: <linux-kernel-owner+w=401wt.eu-S965002AbXIGA5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965002AbXIGA5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 20:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964878AbXIGA5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 20:57:17 -0400
Received: from smtpoutm.mac.com ([17.148.16.73]:54233 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964877AbXIGA5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 20:57:16 -0400
In-Reply-To: <1189121714.6672.38.camel@heimdal.trondhjem.org>
References: <Pine.LNX.4.64.0708301610290.24730@fbirervta.pbzchgretzou.qr> <1188484155.6755.38.camel@heimdal.trondhjem.org> <1188484337.6755.41.camel@heimdal.trondhjem.org> <Pine.LNX.4.64.0708301640030.24730@fbirervta.pbzchgretzou.qr> <1188486240.6755.51.camel@heimdal.trondhjem.org> <20070830214431.GF10808@fieldses.org> <alpine.LFD.0.999.0709061333410.3781@enigma.security.iitk.ac.in> <20070906150616.GA28565@fieldses.org> <0D66E86D-8D97-45D7-9C2A-7AB5F42845B5@mac.com> <1189121714.6672.38.camel@heimdal.trondhjem.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <5B1FC03A-6819-4C6C-91D3-F3022B798EF4@mac.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Satyam Sharma <satyam@infradead.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: NFS4 authentification / fsuid
Date: Thu, 6 Sep 2007 20:56:12 -0400
To: Trond Myklebust <trond.myklebust@fys.uio.no>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 06, 2007, at 19:35:14, Trond Myklebust wrote:
> On Thu, 2007-09-06 at 19:30 -0400, Kyle Moffett wrote:
>> Actually, that's a fairly simple problem (barring disassembling  
>> the system and attaching a hardware debugger).  You encrypt the  
>> root filesystem and require a password to boot (See: LUKS).   
>> Debian has built-in support for installing onto fs-on-LVM-on-crypt- 
>> on-RAID, and it works quite well on all the laptops I use  
>> regularly.  It's not even much of a speed penalty; once you take  
>> the overhead of hitting a 5400RPM laptop drive you can chew  
>> thousands of cycles of CPU without anybody noticing (much).  Then  
>> all you have to do is burn a copy of your /boot with bootloader  
>> onto some read-only media (like a finalized CDROM/DVDROM) and  
>> you're set to go.
>
> Disconnect battery, and watch boot password go 'poof!'.

Umm, I did say "encrypt the root filesystem", didn't I?  Booting my  
laptops this way follows this procedure:
   1) Enter BIOS boot menu
   2) Insert /boot CDROM
   3) Select the "CDROM" entry
   4) Wait for kernel to start and run through initramfs
   5) Type password into the initramfs prompt so that it can DECRYPT  
THE ROOT FILESYSTEM
   6) Continue to boot the system.

Under this setup, tinkering with my BIOS does virtually nothing; the  
only avenues of attack are strictly of the "Install a hardware  
keylogger" variety.  Without my "boot" password you are looking at a  
block device which appears to be little more than a random bit- 
bucket, using AES-256 encryption.  If you can break that by  
disconnecting the BIOS battery a lot of governments would be very  
interested in the exact procedure. :-D  Furthermore if I think that  
the hardware has been compromised I can pull out the HDD and my CDROM  
and take them to a trusted computer to gain access to my data.

That said, a useful BIOS password helps keep somebody from casually  
setting a supervisor password or mucking with the critical-to-boot  
settings and making _me_ unplug the battery.

Cheers,
Kyle Moffett
