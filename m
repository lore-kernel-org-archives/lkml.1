Return-Path: <linux-kernel-owner+w=401wt.eu-S1754555AbZHKUzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbZHKUzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 16:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbZHKUzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 16:55:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:22558 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbZHKUzS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 16:55:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,362,1246863600"; 
   d="scan'208";a="438119845"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "'Neil Horman'" <nhorman@redhat.com>, "'Amerigo Wang'" <amwang@redhat.com>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'linux-ia64@vger.kernel.org'" <linux-ia64@vger.kernel.org>,
       "'Eric W. Biederman'" <ebiederm@xmission.com>,
       "'Andi Kleen'" <andi@firstfloor.org>,
       "'akpm@linux-foundation.org'" <akpm@linux-foundation.org>,
       "'Ingo Molnar'" <mingo@elte.hu>
Date: Tue, 11 Aug 2009 13:55:16 -0700
Subject: RE: [RFC Patch 2/2] kexec: allow to shrink reserved memory
Thread-Topic: [RFC Patch 2/2] kexec: allow to shrink reserved memory
Thread-Index: AcoafNV2m9w1kgAYQEqd5PrqzQ+ELQASJsdg
Message-ID: <A6AD88C3F2289247BE726C37303E1EB8B3A855C2@orsmsx505.amr.corp.intel.com>
References: <20090811104144.5154.77871.sendpatchset@localhost.localdomain>
 <20090811104154.5154.78710.sendpatchset@localhost.localdomain>
 <20090811104606.GA26587@hmsreliant.think-freely.org>
In-Reply-To: <20090811104606.GA26587@hmsreliant.think-freely.org>
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

>On Tue, Aug 11, 2009 at 06:39:32AM -0400, Amerigo Wang wrote:
>>
>> This patch implements shrinking the reserved memory for crash kernel,
>> if it is more than enough.
>>
>> For example, if you have already reserved 128M, now you just want 100M,
>> you can do:
>>
>> # echo $((100*1024*1024)) > /sys/kernel/kexec_crash_size
>>
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>> Cc: Neil Horman <nhorman@redhat.com>
>> Cc: Eric W. Biederman <ebiederm@xmission.com>
>> Cc: Andi Kleen <andi@firstfloor.org>
>>
>
>Since the reserved area is also used for heap in the new kernel, isn't this
>mechanism going to guarantee a non-bootable kernel.  It seems like it
>shrinks
>the reserved area to the size of the image, leaving no additional memory
>for
>heap allocations during the kernels boot.  Or am I missing something?

I think this mechanism need user to have the intelligence to decide the size of memory reserved for crashed kernel. The crash kernel size should include all space a crashed kernel need. This mechanism just does whatever crashed kernel size the user specifies.

Thanks.

-Fenghua
