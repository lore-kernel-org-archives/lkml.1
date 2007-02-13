Return-Path: <linux-kernel-owner+w=401wt.eu-S1751474AbXBMSW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbXBMSW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 13:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbXBMSW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 13:22:26 -0500
Received: from wx-out-0506.google.com ([66.249.82.227]:7391 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbXBMSWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 13:22:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=T4oyRy6aZu1ZkRg7sn83yrNDgl4ggHxfaDDGYTgKTofjjvurNu0iCV8qgK6+uKKTMfDlX3YS9qFsmRWFzxgHY1gGyzA5NueitWJ6n2nQFZ7Q7+qlZ4ZU5x0ibAou1FSxF5WGK0SdaxalkmCD6NLJThbL4jA4LbO49Rs0efsJPDc=
Message-ID: <45D201D6.4050908@gmail.com>
Date: Tue, 13 Feb 2007 10:22:14 -0800
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Joel Soete <soete.joel@scarlet.be>
CC: Luming Yu <luming.yu@gmail.com>, Alan Cox <alan@redhat.com>,
       Ioan Ionita <opslynx@gmail.com>, Alan <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com
Subject: Re: 2.6.20-rc6 libata PATA ATAPI CDROM is not working
References: <df47b87a0611161522o3ad007f5i8804c876c50e591c@mail.gmail.com>	 <20061116235048.3cd91beb@localhost.localdomain>	 <df47b87a0611161730p70e1dd41iad7d27a0bf9283ff@mail.gmail.com>	 <df47b87a0611161734h818fc4dneaad5eeaa7e3c392@mail.gmail.com>	 <20061117100559.GA10275@devserv.devel.redhat.com>	 <459286C2.7080705@scarlet.be> <45943C15.4010506@scarlet.be>	 <459B31AE.709@gmail.com> <459BE5AC.70703@scarlet.be>	 <45BB51F9.5070100@scarlet.be> <3877989d0701270610h7a950125n10d439c3bebce9d0@mail.gmail.com> <45BB64F1.1000105@scarlet.be> <45CFBBD1.5090703@gmail.com> <45D0D133.8070801@scarlet.be> <45D1F6E4.2080102@scarlet.be>
In-Reply-To: <45D1F6E4.2080102@scarlet.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Joel.

Joel Soete wrote:
> A small update:
> your patch also works against 2.6.20

Glad to hear that.

> but seems that open the door to numerous other pb:
> 1/ pb to burn cd:
> # md5sum cd060213.iso
> 6a1248783a21722816b972aa9bae9d5e  cd060213.iso
> 
> # ll cd060213.iso
> -rwxr-xr-x 1 root root 3213312 Feb 13  2006 cd060213.iso
> 
> # dd if=/dev/sr0 bs=1 count=3213312 | md5sum
> dd: reading `/dev/sr0': Input/output error
> 0337e9846d17779945c5c252d4f897f0  -
> 3129344+0 records in
> 3129344+0 records out
> 3129344 bytes (3.1 MB) copied, 36.6963 seconds, 85.3 kB/s
> 
> eventhought cdrecord seems to be successfull???

Hmm... 82K difference.  Can you burn an iso and md5sum the files 
contained in the image and burned cd?

> 2/ (but that should be much more related to scsi api) sdcXX > sdc15 
> doesn't works ;-(
> # sfdisk -l /dev/sdc
> 
> Disk /dev/sdc: 1826 cylinders, 255 heads, 63 sectors/track
> Units = cylinders of 8225280 bytes, blocks of 1024 bytes, counting from 0
> 
>    Device Boot Start     End   #cyls    #blocks   Id  System
> /dev/sdc1   *      0+    195     196-   1574338+   b  W95 FAT32
> /dev/sdc2        196    1825    1630   13092975    5  Extended
> /dev/sdc3          0       -       0          0    0  Empty
> /dev/sdc4          0       -       0          0    0  Empty
> /dev/sdc5   *    196+    197       2-     16033+  83  Linux
> /dev/sdc6   *    198+    199       2-     16033+  83  Linux
> /dev/sdc7        200+    201       2-     16033+  83  Linux
> /dev/sdc8        202+    217      16-    128488+  82  Linux swap / Solaris
> /dev/sdc9        218+    478     261-   2096451   83  Linux
> /dev/sdc10       479+    486       8-     64228+  83  Linux
> /dev/sdc11       487+    488       2-     16033+  83  Linux
> /dev/sdc12       489+    504      16-    128488+  83  Linux
> /dev/sdc13       505+    618     114-    915673+  83  Linux
> /dev/sdc14       619+    620       2-     16033+  83  Linux
> /dev/sdc15       621+    636      16-    128488+  83  Linux
> /dev/sdc16       637+    644       8-     64228+  83  Linux
> /dev/sdc17       645+    646       2-     16033+  83  Linux
> /dev/sdc18       647+    654       8-     64228+  83  Linux
> /dev/sdc19       655+    656       2-     16033+  83  Linux
> /dev/sdc20       657+    773     117-    939771   83  Linux
> /dev/sdc21       774+    789      16-    128488+  83  Linux
> /dev/sdc22       790+    880      91-    730926   83  Linux
> /dev/sdc23       881+   1533     653-   5245191   83  Linux
> /dev/sdc24      1795    1825      31     249007+  83  Linux

Whee, you have 24 partitions?  Due to the way SCSI block device numbers 
are laid out, SCSI supports only upto 15 partitions per device.

-- 
tejun
