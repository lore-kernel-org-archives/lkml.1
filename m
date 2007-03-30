Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbXC3SGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbXC3SGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 14:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbXC3SGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 14:06:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318AbXC3SGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 14:06:40 -0400
Message-ID: <460D51AA.2080307@redhat.com>
Date: Fri, 30 Mar 2007 14:06:34 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: tino.keitel@gmx.de
CC: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] UDF cleanup and fixes
References: <20070306164447.GC3661@duck.suse.cz> <20070330045923.GA5528@dose.home.local>
In-Reply-To: <20070330045923.GA5528@dose.home.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tino Keitel wrote:
> On Tue, Mar 06, 2007 at 17:44:47 +0100, Jan Kara wrote:
>>   Hello,
>>
>>   the patches attached to six following emails implement some cleanup and
>> fixes in the UDF code. The main two fixes are:
>>   1) UDF now works correctly for files larger than 1GB.
> 
> Hi,
> 
> I tried 2.6.20 with your patches and got the following behaviour:
> 
> $ ls -la dvd.udf 
> -rw-r--r-- 1 root root 4699717632 Mar 29 15:36 dvd.udf
> $ mount -o loop -t udf dvd.udf /media/udf/
> $ df /media/udf/
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /home/storage/dvd.udf
>                        4588506 -8584746354 8589334860   -  /media/udf
>                                ^^^^^^^^^^^^^^^^^^^^^^
> $ ls -la /media/udf/
> total 4587521
> drwxr-xr-x 3 root root        144 Mar 29 15:36 .
> drwxr-xr-x 9 root root       1024 Mar 20 12:02 ..
> -rw-r--r-- 1 root root 4697620480 Mar 29 15:57 bk_usr.tar
> drwxr-xr-x 2 root root         40 Mar 29 15:36 lost+found
> 

Is that on a 32-bit machine?

Seems to work okay on a 64-bit system here:

$ df /mnt/udf
Filesystem           1K-blocks      Used Available Use% Mounted on
/var/tmp/udf_fs        4798938       302   4798636   1% /mnt/udf
$ ll /var/tmp/udf_fs
-rw-r--r-- 1 root root 4915200000 Mar 30 13:49 /var/tmp/udf_fs

And after creating a large file in the filesystem:

$ ll /mnt/udf/udf_file
-rw-r--r-- 1 root root 4751360000 Mar 30 14:01 /mnt/udf/udf_file
$ df /mnt/udf
Filesystem           1K-blocks      Used Available Use% Mounted on
/var/tmp/udf_fs        4798938   4640304    158634  97% /mnt/udf


