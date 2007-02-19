Return-Path: <linux-kernel-owner+w=401wt.eu-S932860AbXBSWAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860AbXBSWAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 17:00:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932863AbXBSWAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 17:00:12 -0500
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:46272 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932853AbXBSWAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 17:00:09 -0500
In-Reply-To: <87vehzqwf6.fsf@duaron.myhome.or.jp>
References: <6EF4DB85-C7D4-445B-B9B5-0D22D5D893CD@kernel.crashing.org> <87vehzqwf6.fsf@duaron.myhome.or.jp>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <04C493C2-1D8D-41B7-955A-F5C5B08023BB@kernel.crashing.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: 2.6.20 kernel hang with USB drive and vfat doing ftruncate
Date: Mon, 19 Feb 2007 15:58:53 -0600
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 18, 2007, at 10:10 AM, OGAWA Hirofumi wrote:

> Kumar Gala <galak@kernel.crashing.org> writes:
>
>> I'm seeing an issue with a stock 2.6.20 kernel running on an embedded
>> PPC.  I've got a usb flash drive plugged in and the filesystem on the
>> drive is vfat.  Running with 64M and no swap.
>>
>> If I execute a series of large (100M+) ftruncate() on the disk the
>> kernel will hang and never return.  It seems to be stuck in the idle
>> loop().
>>
>> The following is the test program I'm running:
>>
>> #include <sys/mman.h>
>> #include <sys/types.h>
>> #include <sys/stat.h>
>> #include <fcntl.h>
>> #include <stdio.h>
>> #include <unistd.h>
>> #include <errno.h>
>>
>> void usage (void)
>> {
>>          printf ("truncate_test <filename> <size>\n\n");
>> }
>>
>> int main(int argc, char *argv[])
>> {
>>          int fd, i;
>>          int ret = 0;
>>          unsigned int len;
>>
>>          if (argc != 3) {
>>                  printf("Invalid number of arguments\n\n");
>>                  usage();
>>                  exit(1);
>>          }
>>
>>          fd = open(argv[1], O_CREAT|O_RDWR|O_TRUNC, S_IRWXU);
>>          len = strtoul(argv[2], NULL, 0);
>>
>>          ret = ftruncate(fd, len);
>>
>>          if (ret)
>>                  printf ("ftruncate ret = %d %d\n", ret, errno);
>>
>>          close(fd);
>>
>>          return ret;
>> }
>>
>> I usually run the following twice to get the hang state:
>>
>> time ./trunc_test bar 100000000 &
>> time ./trunc_test baz 100000000 &
>>
>> I was wondering if anyone had any suggestions on what to poke at next
>> to try and figure out what is going on.
>
> Can you check /sys/block/xxx/stat or something to make sure there is
> no outstanding IO request?
>
> It seems to be no response from the lower layer...

Once the system locks up I dont have any ability to do anything.

- k
