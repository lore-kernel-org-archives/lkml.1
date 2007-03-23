Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbXCWSM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbXCWSM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 14:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbXCWSMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 14:12:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:36701 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271AbXCWSMY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 14:12:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,320,1170662400"; 
   d="scan'208"; a="201663218:sNHT21209958"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RFC][Patch 1/4] kprobe fast unregistration
Date: Fri, 23 Mar 2007 11:12:22 -0700
Message-ID: <16D5B9AB904B0B46B22A27002EE3A8C82793BB@scsmsx415.amr.corp.intel.com>
In-Reply-To: <20070323180527.GA13728@bambi.jf.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC][Patch 1/4] kprobe fast unregistration
thread-index: Acdtc4PvhszlZgacRR+Cv5+LRHROgwAAgZSQ
From: "Stone, Joshua I" <joshua.i.stone@intel.com>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       "Masami Hiramatsu" <masami.hiramatsu.pt@hitachi.com>
Cc: "Ananth N Mavinakayanahalli" <ananth@in.ibm.com>,
       "Prasanna S Panchamukhi" <prasanna@in.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "SystemTAP" <systemtap@sources.redhat.com>,
       "Satoshi Oshima" <soshima@redhat.com>, "Hideo Aoki" <haoki@redhat.com>,
       "Yumiko Sugita" <yumiko.sugita.yf@hitachi.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, <hch@infradead.org>
X-OriginalArrivalTime: 23 Mar 2007 18:12:23.0165 (UTC) FILETIME=[CDEB0AD0:01C76D76]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Keshavamurthy, Anil S wrote:
> I agree with Christop that the interface is horrible and error prone.
> However, I see the use case where people want to disable the probes
> quickly and would like to reenable them again. Looking closely at
> your patch, 
> I think this can be acheived.
> Here is my suggestion.
> 
>> Here is an example code.
>> --
>> struct kprobes *p;
>> for_each_probe(p) {
>> 	unregister_kprobe_fast(p);
>         ^^^^^^^^^^^^^^^^^^^^^^
> Change this to disable_kprobe(p), which is essentially the same as
> what you have implemented. And also provide an opposite function
> to reenable_kprobe(p) which enables the disabled probe again.
>> }
>> commit_kprobes();
>   ^^^^^^^^^^^^^^
> Change this to unregister_disabled_kprobes(), which essentially
> unregisters all the disabled probes.

The ability to disable/reenable kprobes would be an interesting
enhancement.  However, unregister_disabled_kprobes() shouldn't have a
global effect, because there might be a concurrent kprobes user that
disabled a probe with the intention of reenabling it later.


Josh Stone
