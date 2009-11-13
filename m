Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbZKMFeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbZKMFeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 00:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbZKMFeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 00:34:12 -0500
Received: from mga03.intel.com ([143.182.124.21]:33130 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbZKMFeM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 00:34:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,734,1249282800"; 
   d="scan'208";a="211023434"
From: "Ma, Ling" <ling.ma@intel.com>
To: Pavel Machek <pavel@ucw.cz>
CC: "H. Peter Anvin" <hpa@zytor.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 13 Nov 2009 13:33:21 +0800
Subject: RE: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
	fast string.
Thread-Topic: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
	fast string.
Thread-Index: Acpj7G92jgQh4Zx1SE2rI8a8Vx3OWAAMDojw
Message-ID: <8FED46E8A9CA574792FC7AACAC38FE7714FEB070EE@PDSMSX501.ccr.corp.intel.com>
References: <1257500482-16182-1-git-send-email-ling.ma@intel.com>
 <4AF457E0.4040107@zytor.com> <4AF4784C.5090800@zytor.com>
 <8FED46E8A9CA574792FC7AACAC38FE7714FCF772C9@PDSMSX501.ccr.corp.intel.com>
 <20091112121604.GC1394@ucw.cz>
In-Reply-To: <20091112121604.GC1394@ucw.cz>
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

>Well, so you are running cache hot and it is only a win on huge
>copies... how common are those?
>
Hi Pavel Machek
Yes, we intend to introduce movsq for huge hot size(over 1024bytes)
and avoid regression for less 1024bytes. I guess you suggest using
prefetch instruction for cold data (if I was wrong please correct me).
memcpy don't know whether data has been in cache or not,
so only when copy size is over (first level 1 cache)/2 and lower
(last level cache)/2 , prefetch will get benefit. Currently first
level cache size of most cpus is around 32KB, so it is useful for prefetch 
when copy size is over 16KB, but as H. Peter Anvin mentioned in last email,
over 16KB copy in kernel is rare.

Thanks
Ling   

