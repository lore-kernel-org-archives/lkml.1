Return-Path: <linux-kernel-owner+w=401wt.eu-S1757597AbZBTDBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbZBTDBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 22:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756697AbZBTDBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 22:01:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:46296 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756606AbZBTDBV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 22:01:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,238,1233561600"; 
   d="scan'208";a="388317557"
From: "Zhang, Xiantao" <xiantao.zhang@intel.com>
To: Joerg Roedel <joro@8bytes.org>, Hollis Blanchard <hollisb@us.ibm.com>
CC: kvm-devel <kvm@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinder@infradead.org>,
       Avi Kivity <avi@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 20 Feb 2009 11:00:40 +0800
Subject: RE: kvm-userspace build break (linux/types.h)
Thread-Topic: kvm-userspace build break (linux/types.h)
Thread-Index: AcmS3foBq0Epzr5pQ4eddIPvzj+7NwAKOwDQ
Message-ID: <706158FABBBA044BAD4FE898A02E4BC22422B4C6@pdsmsx503.ccr.corp.intel.com>
References: <1235080214.16221.26.camel@slate.austin.ibm.com>
 <20090219220315.GI2125@8bytes.org>
In-Reply-To: <20090219220315.GI2125@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For x86 and ia64,  linux/types.h will be hacked to asm/types.h when syncing the source. 
You may consult kernel/x86/hack-module.awk to get the answer.  
Xiantao

Joerg Roedel wrote:
> On Thu, Feb 19, 2009 at 03:50:14PM -0600, Hollis Blanchard wrote:
>> A recent kernel merge breaks kvm-userspace build:
>>         make[1]: Entering directory
>>         `/root/hollisb/kvm-userspace.git/libkvm' gcc -m64
>>         -D__x86_64__ -MMD -MF ./.libkvm.d -g -fomit-frame-pointer
>>                          -Wall  -fno-stack-protector   -I
>>                         
>>         /root/hollisb/kvm-userspace.git/kernel/include   -c -o
>>         libkvm.o libkvm.c In file included from
>>         /usr/include/bits/fcntl.h:24, from /usr/include/fcntl.h:34,
>>         from libkvm.c:30: /usr/include/sys/types.h:46: error:
>> conflicting types for 'loff_t' /usr/include/linux/types.h:30: error:
>> previous declaration of 'loff_t' was here
>> /usr/include/sys/types.h:62: error: conflicting types for 'dev_t'
>> /usr/include/linux/types.h:13: error: previous declaration of
>> 'dev_t' was here         [...]     
>> 
>> I built like so:
>>         ./configure
>>         make -C kernel LINUX=/path/to/kvm.git sync
>>         make
>> 
>> The problem appears to be 00bfddaf7f68a6551319b536f052040c370756b0
>> and 
>> cef3767852a9b1a7ff4a8dfe0969e2d32eb728df, both from Jaswinder Singh
>> Rajput <jaswinder@infradead.org>:
>>         -#include <asm/types.h>
>>         +#include <linux/types.h>
>> 
>> With these changes, libkvm.c ends up
>> including /usr/include/linux/types.h, instead of the
>> intended ../kernel/include/linux/types.h.
> 
> I had the same problem some weeks ago. IIRC I fixed it with some
> include reordering in libkvm.h.
> 
> Joerg

