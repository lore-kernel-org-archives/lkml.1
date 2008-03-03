Return-Path: <linux-kernel-owner+w=401wt.eu-S1759723AbYCCEnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759723AbYCCEnS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 23:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbYCCEnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 23:43:08 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:39796 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbYCCEnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 23:43:06 -0500
Message-ID: <47CB81C6.6020402@ak.jp.nec.com>
Date: Mon, 03 Mar 2008 13:42:46 +0900
From: Kohei KaiGai <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: greg@kroah.com, morgan@kernel.org, serue@us.ibm.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] add a private data field within kobj_attribute structure
 (final#2)
References: <47C25AE9.7080305@ak.jp.nec.com>            <47C25BD3.3020205@ak.jp.nec.com> <7086.1204177759@turing-police.cc.vt.edu>
In-Reply-To: <7086.1204177759@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Mon, 25 Feb 2008 15:10:27 +0900, Kohei KaiGai said:
>> [PATCH 1/3] add a private data field within kobj_attribute structure.
> 
>> diff --git a/Documentation/kobject.txt b/Documentation/kobject.txt
>> index bf3256e..efa5d71 100644
>> --- a/Documentation/kobject.txt
>> +++ b/Documentation/kobject.txt
>> @@ -207,6 +207,12 @@ Both types of attributes used here, with a kobject that has been created
>>  with the kobject_create_and_add(), can be of type kobj_attribute, so no
>>  special custom attribute is needed to be created.
>>
>> +The simple kobj_attribute is prototyped at include/linux/kobject.h, and can
>> +contain your own show()/store() method and private data.
>> +When an attribute is accessed, these methods are invoked with kobject,
>> +kobj_attribute and read/write buffer. The method can refer the private data
>> +via given kobj_attribute, to show/store itself in the text representation.
>> +
>>  See the example module, samples/kobject/kobject-example.c for an
>>  implementation of a simple kobject and attributes.
> 
> OK, I'm an idiot, so I re-read this several times, and looked at patch 3/3
> that added the sample code, and I'm still confoozled.
> 
> Who creates/destroys/manages this "read/write buffer", and/or how does the
> method know how large a buffer is available, so (for example) it can use the
> strn* versions of string functions to be sure not to run off the end?  Does
> this buffer have any lifetime rules attached to it?

This "read/write buffer" is managed by sysfs filesystem.

Sysfs is invoked via kernel VFS subsystem, when user calls read(2) or write(2).
In the read(2) case, sysfs_read_file() is invoked, allocates a page for buffer,
and calls the show() method to generate the containts of this pseudo file entry.
Therefore, show() and store() method does not need to manage this buffer.

When store() method is invoked with data from userspace, sysfs terminate it with
'\0' implicitly. The size of buffer is also limited to PAGE_SIZE implicitly.

Can you make it clear?

Thanks,
-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>
