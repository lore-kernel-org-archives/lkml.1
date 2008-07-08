Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbYGHTfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbYGHTfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 15:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbYGHTe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 15:34:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:53018 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378AbYGHTe4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 15:34:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,325,1212390000"; 
   d="scan'208";a="586734990"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Check for BIOS bugs - Original Subject: Re: [PATCH 23/70] ACPICA: Workaround for reversed _PRT entries from BIOS
Date: Tue, 8 Jul 2008 12:34:55 -0700
Message-ID: <960B77DF2E6D974DBE24FD066EAEE8DAD90886@azsmsx422.amr.corp.intel.com>
In-Reply-To: <48738A65.9060905@linux.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Check for BIOS bugs - Original Subject: Re: [PATCH 23/70] ACPICA: Workaround for reversed _PRT entries from BIOS
Thread-Index: AcjhEO3E3ztaUQRQSGOuDRLxkT2F/QAGtitA
References: <1213947852-10924-1-git-send-email-lenb@kernel.org> <deade3c973eb9c98d2a6cfed658bbb49e693894a.1213947350.git.len.brown@intel.com> <200807011033.27887.trenn@suse.de> <20080707111207.GH5643@ucw.cz> <48738A65.9060905@linux.intel.com>
From: "Brown, Len" <len.brown@intel.com>
To: "Arjan van de Ven" <arjan@linux.intel.com>, "Pavel Machek" <pavel@suse.cz>
Cc: "Thomas Renninger" <trenn@suse.de>, "Len Brown" <lenb@kernel.org>,
       <linux-acpi@vger.kernel.org>, "Moore, Robert" <robert.moore@intel.com>,
       "Lin, Ming M" <ming.m.lin@intel.com>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Huang Cheng" <cheng.huang@intel.com>,
       <firmwarekit-discuss@bughost.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 08 Jul 2008 19:34:55.0820 (UTC) FILETIME=[B351F8C0:01C8E131]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>>>> Some BIOSs erroneously reverse the _PRT SourceName and the
>>>> SourceIndex.  Detect and repair this problem. MS ACPI also allows
>>>> and repairs this problem, thus ACPICA must also.
>>> It would be great to have an interface to report this as a 
>BIOS defect.
>>>
>>> Something like:
>>>
>>> FIRMWARE_BUG_ON(FIRM_WARN, "erroneously reversed the _PRT 
>source_name", ACPI_ 
>>> Bug);
>>>
>>> FIRMWARE_BUG_ON(severity, description, component);
>> 
>> Yes, please.

I'm not excited about maintaining
maintaining linux-as-a-firmware-diagnostic --
particularly when...

1. it clutters the code for normail machines
2. finding the bug is pointless, because even
   if you fix one machine, you are guaranteed to
   not fix all machines and thus must maintain
   the workaround anyway.

>> I'd also like HARDWARE_BUG_ON(), with similar usage.
>> 
>> With all the preload-linux-on-foo project, we have some 
>> chance to make
>> BIOS vendors fix their stuff if we can easily diagnose errors in
>> there.

These customers should be running 
http://linuxfirmwarekit.org/

We do maintain some degree of "high-road ACPI spec checking"
with the "acpi=strict" boot option.  If we do more of this,
I think it should stay under that option.

thanks,
-Len
