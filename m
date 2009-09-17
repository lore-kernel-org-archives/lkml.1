Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbZIQVTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbZIQVTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 17:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbZIQVTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 17:19:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:35307 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133AbZIQVTV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 17:19:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,405,1249282800"; 
   d="scan'208";a="494516585"
From: "Moore, Robert" <robert.moore@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg@redhat.com>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 17 Sep 2009 14:19:23 -0700
Subject: RE: [PATCH 1/3] ACPI: Add infrastructure for refcounting GPE
 consumers
Thread-Topic: [PATCH 1/3] ACPI: Add infrastructure for refcounting GPE
 consumers
Thread-Index: Aco2S+A3Eyn9NtJCQzyRdxR0pdvMgABjw+3A
Message-ID: <4911F71203A09E4D9981D27F9D8308583774349D@orsmsx503.amr.corp.intel.com>
References: <20090902181014.GA10917@srcf.ucam.org>
 <1251915173-10144-1-git-send-email-mjg@redhat.com>
 <200909152330.38874.rjw@sisk.pl>
In-Reply-To: <200909152330.38874.rjw@sisk.pl>
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

I have a couple of comments and questions:

1) The core issue that needs to be solved concerns enabling/disabling the wake and wake/run GPEs, is this correct? As far as I can tell, the normal runtime GPEs do not need any change. The runtime GPEs are mostly defined by _Lxx/_Exx methods. The main exception to this is the EC, it has a GPE defined by the _GPE method under the EC device. Are there any issues here?

2) A large change that goes unmentioned is that the ACPICA core would no longer execute the _PRW control methods in order to discover the wake GPEs. This makes sense to me because it is clear that the bus scan code must execute these _PRW methods anyway, in order to obtain the wake GPE and other info. So it makes sense to just remove the _PRW and wake GPE management code from ACPICA and let the host OS and drivers handle this task, since it does it already anyway. Do I understand this correctly?

Thanks,
Bob




>-----Original Message-----
>From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
>Sent: Tuesday, September 15, 2009 2:31 PM
>To: Matthew Garrett
>Cc: Moore, Robert; linux-acpi@vger.kernel.org; linux-kernel@vger.kernel.org
>Subject: Re: [PATCH 1/3] ACPI: Add infrastructure for refcounting GPE
>consumers
>
>On Wednesday 02 September 2009, Matthew Garrett wrote:
>> ACPI GPEs may map to multiple devices. The current GPE interface only
>> provides a mechanism for enabling and disabling GPEs, making it difficult
>> to change the state of GPEs at runtime without extensive cooperation
>> between devices. Add an API to allow devices to indicate whether or not
>> they want their device's GPE to be enabled for both runtime and wakeup
>> events.
>
>Looks fine in general, but are we going to do anything about unbalanced
>puts?
>
>Rafael
>
