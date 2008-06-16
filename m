Return-Path: <linux-kernel-owner+w=401wt.eu-S1757004AbYFPOU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbYFPOU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 10:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbYFPOUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 10:20:08 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:53405 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbYFPOUG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 10:20:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AFPXxkSh+MmKHv20AUzhsZXUiOjlvlS5eRy/Ve+WY3EEem27MBkuwn3g3nXxN0a0dK
         v46kpVEvCPqTKYEdIC9ebBZIwCyUoa8bDjvn1ThriJ2+SFAIwzjPyGCxJvR02eSbyArB
         lWhmV4wxZAmHNimzfGIQ7tKmkPs+oGcONv7JE=
Message-ID: <85e7c2fc0806160720v510a565id709ee782851169d@mail.gmail.com>
Date: Mon, 16 Jun 2008 22:20:04 +0800
From: "Bob Zhang" <zhanglinbao@gmail.com>
To: "Jared Hulbert" <jaredeh@gmail.com>
Subject: Re: Does anyone run AXFS in 2.4 version of kernel ? I am trying my best to apply AXFS patches into 2.4.18
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <85e7c2fc0805190842v6ee5f4f3jef7790b0fa459a21@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <85e7c2fc0805090919v613fb823m8dd979b8cd959889@mail.gmail.com>
	 <6934efce0805120923v636d2dbjb062d33fb861f5a2@mail.gmail.com>
	 <85e7c2fc0805131746k5284d66dj7cfac5f9138186e2@mail.gmail.com>
	 <6934efce0805131801s633a1692ha8914a76173c2c80@mail.gmail.com>
	 <85e7c2fc0805190842v6ee5f4f3jef7790b0fa459a21@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jaredeh,

     First , I admire your devotion to AXFS , you are a great
programmer worth respecting , we pay you a great reverence and pay
homage to your genius on file system . I think AXFS is a huge
contribution to open source.

Now , I could run AXFS in 2.4.21 kernel by skyeye simulator supported
PXA platform . I modified some parts of linux2.4.21 code related with
memory management and ad justed some interfaces of AXFS code to fit
for 2.4, ,once XIP is OK , I will submit my patch.
Till now , all files in the AXFS rootfs image are compressed , they
are working OK . I can run "ls" , "ifconfig" and so on.

But I can't these files run directly XIP , I need your help to configure them .
I am puzzled for how to make files and pages are of XIP not compressed .

In your AXFS howto http://axfs.sourceforge.net/wordpress/?page_id=19
To use AXFS you must follow these steps:

» 1. pre patch kernel
» 2. use patchin.sh script to install files into kernel
» 3. build kernel with AXFS profiling on
» 4. create fully compressed AXFS image
» 5. run usecases with profiling on and fully compressed image
» 6. extract profile from /proc/axfs/volumeX
» 7. create new partially XIP image using the extracted profile
» 8. build kernel with profiling off
» 9. Enjoy!

For easily debugging , I am in 2.6.18 not 2.4.21 to test your method .

In 2.6.18 , my kernel whose axfs profiling on (make menuconfig) , and

Cat /proc/axfs/volume0 ,I can get

================ cat /proc/axfs/volume0   begin ===================

/ $

/ $ cat /proc/axfs/volume0

./bin/busybox,0,18

./bin/busybox,28672,2

./bin/busybox,53248,4

./bin/busybox,143360,3

./bin/busybox,147456,3

./bin/busybox,151552,8

./bin/busybox,155648,11

./bin/busybox,159744,10

./bin/busybox,163840,14

./bin/busybox,167936,4

./bin/busybox,204800,3

./bin/busybox,233472,13

./bin/busybox,237568,13

./bin/busybox,241664,13

./bin/busybox,245760,13

./bin/busybox,249856,3

./bin/busybox,253952,13

./bin/busybox,258048,2

./bin/busybox,262144,2

./bin/busybox,266240,2

./bin/busybox,270336,2

./bin/busybox,274432,2

./bin/busybox,278528,2

./bin/busybox,282624,13

./bin/busybox,286720,1

./bin/busybox,290816,1

./bin/busybox,294912,1

./bin/busybox,303104,1

./bin/busybox,307200,1

./bin/busybox,315392,1

./bin/busybox,339968,4

./bin/busybox,348160,2

./bin/busybox,376832,2

./bin/busybox,380928,15

./bin/busybox,413696,14

./bin/busybox,417792,14

./bin/busybox,421888,13

./bin/busybox,425984,19

./bin/busybox,430080,12

./bin/busybox,434176,7

./bin/busybox,438272,20

./bin/busybox,442368,20

./bin/busybox,446464,15

./bin/busybox,450560,11

./bin/busybox,454656,9

./bin/busybox,466944,11

./bin/busybox,471040,11

./bin/busybox,475136,10

./bin/busybox,479232,2

./bin/busybox,483328,18

./bin/busybox,487424,3

./bin/busybox,491520,10

./bin/busybox,495616,2

./bin/busybox,499712,1

./bin/busybox,503808,13

./bin/busybox,507904,9

./bin/busybox,512000,1

./bin/busybox,516096,2

./bin/busybox,520192,9

./bin/busybox,524288,10

./bin/busybox,528384,7

./bin/busybox,532480,11

./bin/busybox,536576,14



 =================end of cat /proc/axfs/volume0=====================

There are only three columns of outputs ,

>From the source code , this function procfile_read() implement the
proc reading function ,

/* set everything up to print out */

                     len =
                         sprintf(current_buf_ptr,
                                "%s,%lu,%lu \n",
                                name, (unsigned
long)(inode_page_offset * PAGE_SIZE),
                                (profile_data->count));

it will print
./bin/busybox,  507904,         9
filename   page_offset   reference_count

But from your readme of mkfs.axfs.c directory .

You have written that :
Usage Notes

--------------------

1. "./mkfs.axfs [-h] [-i infile] indir outfile"

  -h         print this help
 -i infile  input file of the XIP information
 dirname    root of the directory tree to be compressed
 outfile    output file

About the Input File
--------------------
Input file should be an XML file with specific element name.  See

example_xipfsmap_syntax.xml for an example.
<xipfsmap>
       <file>
             <name>./xxx</name>
              <chunk>
                     <size>aaa</size>
                     <offset>bbb</offset>
              </chunk>
       </file>

</xipfsmap>

 1. Input file is optional.  If the option is not available, the writer will

compress every file.

 I think I need to provide a Input file to tell the mkfs.axfs.c which
files and pages are of XIP .

So I need to provide their names ,size and offset , but "cat
/proc/axfs/volume0" , we can only get

./bin/busybox,  507904,         9

filename   page_offset   reference_count

Would you mind telling me more information or can you give me a fresh
example ? thanks very much!

Best Regards,

Bob
