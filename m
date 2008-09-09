Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbYIIP3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbYIIP3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 11:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbYIIP3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 11:29:13 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:54161 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbYIIP3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 11:29:13 -0400
X-IronPort-AV: E=Sophos;i="4.32,366,1217808000"; 
   d="scan'208";a="1741477"
User-Agent: Microsoft-Entourage/11.4.0.080122
Date: Tue, 09 Sep 2008 16:29:04 +0100
Subject: Re: [Xen-devel] Re: [PATCH 1 of 7] x86: add _PAGE_IOMAP pte flag
 for IO mappings
From: Keir Fraser <keir.fraser@eu.citrix.com>
To: Avi Kivity <avi@qumranet.com>, Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, Xen Devel <xen-devel@lists.xensource.com>,
       Andi Kleen <andi@firstfloor.org>, <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <C4EC54D0.26EEA%keir.fraser@eu.citrix.com>
Thread-Topic: [Xen-devel] Re: [PATCH 1 of 7] x86: add _PAGE_IOMAP pte flag
 for IO mappings
Thread-Index: AckSkMqTCThv/n6EEd2WrgAX8io7RQ==
In-Reply-To: <48C68EA3.4050508@qumranet.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 09 Sep 2008 15:29:11.0052 (UTC) FILETIME=[CEC72CC0:01C91290]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/9/08 15:56, "Avi Kivity" <avi@qumranet.com> wrote:

>> I'm not sure; I still don't really understand how _PAGE_SPECIAL gets
>> used, other than being user-mode mapping only.  But in principle,
>> _PAGE_IOMAP could be set on both kernel and user mappings (if you direct
>> map a device into a process address space), so I think they would
>> conflict then?
> 
> It's a "don't refcount me" flag, which is not sematically the same as
> I/O, but may be close enough.

That's basically what our _PAGE_IO flag (in our old Linux patchset) means.
We use it to cause pte_pfn() to return an invalid pfn and hence avoid
reference counting that way. Since kernel mappings are never reference
counted (I think?) perhaps we could use _PAGE_SPECIAL even if it is
restricted to use on user mappings.

 -- Keir


