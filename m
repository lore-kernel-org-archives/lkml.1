Return-Path: <linux-kernel-owner+w=401wt.eu-S1756970AbZFZXY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbZFZXY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 19:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbZFZXYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 19:24:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:64448 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714AbZFZXYV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 19:24:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,299,1243839600"; 
   d="scan'208";a="528228930"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Date: Fri, 26 Jun 2009 16:24:22 -0700
Subject: RE: [PATCH 9/9] x86/apic: support moorestown interrupt subsystem
Thread-Topic: [PATCH 9/9] x86/apic: support moorestown interrupt subsystem
Thread-Index: Acn2li0+FIUS8g+6Q+azA50WCPUC7AAHBWnQ
Message-ID: <43F901BD926A4E43B106BF17856F0755641A47CD@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F07556412B7E8@orsmsx508.amr.corp.intel.com>
 <m1ab3ubx4q.fsf@fess.ebiederm.org>
In-Reply-To: <m1ab3ubx4q.fsf@fess.ebiederm.org>
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



>-----Original Message-----
>From: Eric W. Biederman [mailto:ebiederm@xmission.com]
>Sent: Friday, June 26, 2009 12:42 PM
>To: Pan, Jacob jun
>Cc: linux-kernel@vger.kernel.org; H. Peter Anvin
>Subject: Re: [PATCH 9/9] x86/apic: support moorestown interrupt subsystem
>
>"Pan, Jacob jun" <jacob.jun.pan@intel.com> writes:
>
>>>From 82d64ca4f963d2e205326534aff0c77d9bfa5858 Mon Sep 17 00:00:00 2001
>> From: Jacob Pan <jacob.jun.pan@intel.com>
>> Date: Fri, 12 Jun 2009 02:16:05 -0700
>> Subject: [PATCH] x86/apic: support moorestown interrupt subsystem
>>
>> This patch uses platform flags to selectively enable apic related setup
>> code.
>>
>> Since moorestown does not have legacy timer or PIC, the only system
>> timer irqs are routed via ioapic. Early timer ioapic enabling is also
>> added to allow boot time timing services.
>
>This patch is horribly wrong.   We should not have a moorestown specific
>hack  we should not do early timer ioapic on everything that supports
>it which is most x86 machines since apics became common.
>
[[JPAN]] maybe I misunderstood. But I am doing the special early timer ioapic
setup in x86_quirks, so it is not for every platform.

>At which point moorestown support should just be a little work somewhere
>in the table parsers.
>
[[JPAN]] can you elaborate a little? I was hoping to move APIC initialization earlier so that I don't have to have the special treatment for system timer.
But it seems require early memory allocator.

>If you can't compile out the 8259 support code this has been factored
>wrong.
>
>There are a handful of legacy systems with mptables that run in ioapic
>mode yet use the timer and sometimes a couple of other devices on
>the 8259 PIC.  Handling that case will complicate things a bit.
>
>Hopefully it will be easier now to properly rework the code.  When
>I tried it.  Linus's laptop died somewhere half way through bootup.
>So we had to revert the support.
>
>In summary if moorestown does not have an 8259 PIC it is time to remove
>this long standing deficiency of the x86 ioapic code, not hack around
>it.
>
[[JPAN]] Moorestown does not have 8259, even IOAPIC is emulated by FW. Are you
saying we should try to completely separate 8259 instead of use if(8259) here
and there in the IOAPIC code? T
>Eric
[[JPAN]] thanks for the feedback.
