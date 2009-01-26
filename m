Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbZAZTrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbZAZTrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 14:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbZAZTq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 14:46:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:10163 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbZAZTq7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 14:46:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,327,1231142400"; 
   d="scan'208";a="425609869"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Hunter, Jon" <jon-hunter@ti.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 26 Jan 2009 11:48:09 -0800
Subject: RE: [RFC] Dynamic Tick and Deferrable Timer Support
Thread-Topic: [RFC] Dynamic Tick and Deferrable Timer Support
Thread-Index: Acl22NMmPRfHmhnyTuem0+yaDRLXwwJCC58gAAMph9A=
Message-ID: <7E82351C108FA840AB1866AC776AEC46471B9452@orsmsx505.amr.corp.intel.com>
References: <CF7665F795A4BE438425FE728CEACFA302F2436B52@dlee01.ent.ti.com>
 <20090114221624.76ee8aa4.akpm@linux-foundation.org>
 <7B4574D56E4ADF438756313E9A172A872CB8232E@dlee01.ent.ti.com>
In-Reply-To: <7B4574D56E4ADF438756313E9A172A872CB8232E@dlee01.ent.ti.com>
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
>From: Hunter, Jon [mailto:jon-hunter@ti.com] 
>Sent: Monday, January 26, 2009 10:24 AM
>To: Andrew Morton; Pallipadi, Venkatesh
>Cc: linux-kernel@vger.kernel.org
>Subject: RE: [RFC] Dynamic Tick and Deferrable Timer Support
>
>Andrew Morton <mailto:akpm@linux-foundation.org> wrote on 
>Thursday, January 15, 2009 12:16 AM:
>
>> Venki, could you please take a look?
>
>Andrew, Venki, if it helps here are some more details.
>

Jon,

I looked at your patch earlier, but I was concerned about few things and wanted to spend some more time on it. So, I did not reply earlier. The potential issues I see:
- May be a bit theoritcal, as this may not happen in reality. But, with your change, if all the timers happen to be defrrable, timer wheel never advances and none of the timers expire. Not sure whether we need to handle this cleanly somehow or assume that not all the timers will be deferrable.
- Another similar case is when we have more of deferrable timers in the system, if we do not cascade timers from the timer wheel, we may end up spending more time in the higher order timer wheel looking through all the timers, as they are at a higher timer granularity, instead of on the lower order timer wheel which will have timers sorted at a lower granularity.

I am not sure whether any of these issues will be a problem in real world or not. But, I think they are something we should be careful about.

Thanks,
Venki 