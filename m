Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbZDPRgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbZDPRgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 13:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755603AbZDPRgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 13:36:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:11245 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018AbZDPRgW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 13:36:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,199,1239001200"; 
   d="scan'208";a="448546153"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>,
       "davidjon@xenontk.org" <davidjon@xenontk.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Thu, 16 Apr 2009 10:38:14 -0700
Subject: RE: X freezes intermittently with 2.6.29.1
Thread-Topic: X freezes intermittently with 2.6.29.1
Thread-Index: Acm+Y4diAOfNvMk6QJOnWJZ1jsuLnwAVlZCA
Message-ID: <7E82351C108FA840AB1866AC776AEC46587A0784@orsmsx505.amr.corp.intel.com>
References: <49E6D8FE.80908@xenontk.org>
 <86802c440904160018j5c4842d8t92742b6a1b2e4514@mail.gmail.com>
In-Reply-To: <86802c440904160018j5c4842d8t92742b6a1b2e4514@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Specifically the patch here will help (not sure whether it cleanly applies over 29.1.

http://marc.info/?l=linux-kernel&m=123923026401648&w=2

Thanks,
Venki
 

>-----Original Message-----
>From: Yinghai Lu [mailto:yhlu.kernel@gmail.com] 
>Sent: Thursday, April 16, 2009 12:18 AM
>To: davidjon@xenontk.org
>Cc: linux-kernel@vger.kernel.org; Pallipadi, Venkatesh; Ingo 
>Molnar; Jesse Barnes
>Subject: Re: X freezes intermittently with 2.6.29.1
>
>On Thu, Apr 16, 2009 at 12:06 AM, David John 
><davidjon@xenontk.org> wrote:
>> Hi All,
>>
>> With 2.6.29.1 (stock kernel), on my Dell Inspiron 1545, X freezes for
>> 15-20 seconds at a time randomly every 10 seconds or so making it
>> unusable. Currently, I use the 2.6.29.1-54.fc11.x86_64 
>kernel that comes
>> with Fedora 11 Beta which has the same problem but only when 
>X is left
>> idle for a period of time. The kernel log is overrun by 
>messages of the
>> type:
>>
>> X:2802 freeing invalid memtype e4b42000-e4b43000
>> X:2802 freeing invalid memtype e4b43000-e4b44000
>> X:2802 freeing invalid memtype e4b44000-e4b45000
>
>can you try tip?
>http://people.redhat.com/mingo/tip.git/readme.txt
>
>it seems include one patch for that.
>
>>
>> This I believe is related to this:
>>
>> mtrr: type mismatch for e0000000,10000000 old: write-back new:
>> write-combining
>> [drm] MTRR allocation failed.  Graphics performance may suffer.
>>
>> The MTRR setup is below:
>> reg00: base=0x000000000 (    0MB), size=32768MB, count=1: write-back
>> reg01: base=0x0e0000000 ( 3584MB), size=  512MB, count=1: uncachable
>> reg02: base=0x07dc00000 ( 2012MB), size=    4MB, count=1: uncachable
>> reg03: base=0x07e000000 ( 2016MB), size=   32MB, count=1: uncachable
>>
>> I think the first entry is bogus. Both kernels come with the
>> MTRR sanitize option enabled but the code is unable to find an
>> optimal value. Is there any way to correct this? What values for
>> mtrr_gran_size and mtrr_chunk_size would be appropriate?
>
>gran_size: 32M 	chunk_size: 128M 	num_reg: 7  	
>lose cover RAM: 28M
>
>YH
>