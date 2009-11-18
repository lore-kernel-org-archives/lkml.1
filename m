Return-Path: <linux-kernel-owner+w=401wt.eu-S1757998AbZKRR02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbZKRR02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757905AbZKRR01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:26:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:12405 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757816AbZKRR01 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:26:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,766,1249282800"; 
   d="scan'208";a="515165844"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Xiaotian Feng <dfeng@redhat.com>, "x86@kernel.org" <x86@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Date: Wed, 18 Nov 2009 09:30:58 -0800
Subject: RE: [PATCH] x86/pat: no need to check overlaps with more than one
 entry in chk_conflict
Thread-Topic: [PATCH] x86/pat: no need to check overlaps with more than one
 entry in chk_conflict
Thread-Index: AcpoAYzFyqyl8wxfRzS1zs+PLRoMRwAcvGNA
Message-ID: <7E82351C108FA840AB1866AC776AEC46767A389F@orsmsx505.amr.corp.intel.com>
References: <1258512455-1891-1-git-send-email-dfeng@redhat.com>
In-Reply-To: <1258512455-1891-1-git-send-email-dfeng@redhat.com>
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
>From: linux-kernel-owner@vger.kernel.org 
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Xiaotian Feng
>Sent: Tuesday, November 17, 2009 6:48 PM
>To: x86@kernel.org
>Cc: linux-kernel@vger.kernel.org; Xiaotian Feng; Ingo Molnar; 
>Siddha, Suresh B; Pallipadi, Venkatesh
>Subject: [PATCH] x86/pat: no need to check overlaps with more 
>than one entry in chk_conflict
>
>memtype list is built via reserve_memtype, for the overlapped 
>areas, they're
>all the same type, otherwise reserve_memtype will fail to 
>insert it into the
>list. So there's no need to check overlaps with more than one 
>entry in the
>chk_conflict code.

NAK.

The reason we have to check for more than one entry is for the cases
like this.

New entry:                   s-------------------e
Existing entries:         s----e     s-----e   s----e
(s=start, e=end)

Thanks,
Venki