Return-Path: <linux-kernel-owner+w=401wt.eu-S964778AbXBTLVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964778AbXBTLVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 06:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964774AbXBTLVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 06:21:38 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:58966 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932887AbXBTLVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 06:21:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=dYAZnCwKM5UDNTIwi+CqJlzlRdjkC3PCWf3VdBOVE1absJm4PI+F3JCJjLIN5etVhgTVpU1h+941iAzb4kdzIoxnIOx+Rcn6bnYLugbk2RbiuNuIiUUriyFyLsLc24Rw8thoOo92Mu81dc1hIKzARmqLbhZgI1IPmCCZBNdDHzI=
Message-ID: <45DAD9BC.8040008@gmail.com>
Date: Tue, 20 Feb 2007 20:21:32 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Joel Soete <soete.joel@scarlet.be>
CC: Luming Yu <luming.yu@gmail.com>, Alan Cox <alan@redhat.com>,
       Ioan Ionita <opslynx@gmail.com>, Alan <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com
Subject: Re: 2.6.20-rc6 libata PATA ATAPI CDROM is not working
References: <df47b87a0611161522o3ad007f5i8804c876c50e591c@mail.gmail.com>	 <20061116235048.3cd91beb@localhost.localdomain>	 <df47b87a0611161730p70e1dd41iad7d27a0bf9283ff@mail.gmail.com>	 <df47b87a0611161734h818fc4dneaad5eeaa7e3c392@mail.gmail.com>	 <20061117100559.GA10275@devserv.devel.redhat.com>	 <459286C2.7080705@scarlet.be> <45943C15.4010506@scarlet.be>	 <459B31AE.709@gmail.com> <459BE5AC.70703@scarlet.be>	 <45BB51F9.5070100@scarlet.be> <3877989d0701270610h7a950125n10d439c3bebce9d0@mail.gmail.com> <45BB64F1.1000105@scarlet.be> <45CFBBD1.5090703@gmail.com> <45D0D133.8070801@scarlet.be> <45D1F6E4.2080102@scarlet.be> <45D201D6.4050908@gmail.com> <45D6DFC8.4060503@scarlet.be>
In-Reply-To: <45D6DFC8.4060503@scarlet.be>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joel Soete wrote:
> Ok comparing the content of the original image:
> # mount -t iso9660 -o ro -o loop /MultiCd/cd060213.iso /mnt/cd
> # find /mnt/cd -type f -exec md5sum {} \;
> 37149d4961c0484f2cceb1a1614b253d  /mnt/cd/boot.cat
> 4ab996554b0e7ade115a3f284b876612  /mnt/cd/boot.msg
> fbdc51c29d54dd227427b2ef90e1961e  /mnt/cd/initrd.cgz
> 92c9a50bed71257c29f069ec5dd819fc  /mnt/cd/isolinux.bin
> 927ce1096693b3a44af0e0d8a2ad720c  /mnt/cd/isolinux.cfg
> 4afcf65ff8259a3bccd0cf9f91675529  /mnt/cd/scsi.cgz
> 4714742585da795c3a69c262ce8c35ef  /mnt/cd/vmlinuz
> 
> and the content of the burned cd:
> # mount /cdrom
> # find /cdrom -type f -exec md5sum {} \;
> 37149d4961c0484f2cceb1a1614b253d  /cdrom/boot.cat
> 4ab996554b0e7ade115a3f284b876612  /cdrom/boot.msg
> fbdc51c29d54dd227427b2ef90e1961e  /cdrom/initrd.cgz
> 92c9a50bed71257c29f069ec5dd819fc  /cdrom/isolinux.bin
> 927ce1096693b3a44af0e0d8a2ad720c  /cdrom/isolinux.cfg
> 4afcf65ff8259a3bccd0cf9f91675529  /cdrom/scsi.cgz
> 4714742585da795c3a69c262ce8c35ef  /cdrom/vmlinuz
> 
> it seems ok?
> 
> What is it lost???

Probably length got screwed somewhere.  Hmm... will do some testing.

>>> 2/ (but that should be much more related to scsi api) sdcXX > sdc15
>>> doesn't works ;-(
>>> # sfdisk -l /dev/sdc
>>>
>>> Disk /dev/sdc: 1826 cylinders, 255 heads, 63 sectors/track
>>> Units = cylinders of 8225280 bytes, blocks of 1024 bytes, counting
>>> from 0
>>>
>>>    Device Boot Start     End   #cyls    #blocks   Id  System
>>> /dev/sdc1   *      0+    195     196-   1574338+   b  W95 FAT32
>>> /dev/sdc2        196    1825    1630   13092975    5  Extended
> [snip]
>>> /dev/sdc23       881+   1533     653-   5245191   83  Linux
>>> /dev/sdc24      1795    1825      31     249007+  83  Linux
>>
>> Whee, you have 24 partitions?
> yes: it was dated from the early time I was testing various distro to
> choose one ;-)
> 
>>  Due to the way SCSI block device numbers are laid out, SCSI supports
>> only upto 15 partitions per device.
>>
> Ah, I never had chance to use a disk array with fc connection on one of
> my linux boxe, so I don't know how can it works with up to 255 luns?

Each lun is handled as a separate scsi device and as such allocated 16
minor numbers if it is a block device.  Will check if the minor number
limit can be worked around somehow.

-- 
tejun
