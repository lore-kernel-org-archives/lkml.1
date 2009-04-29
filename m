Return-Path: <linux-kernel-owner+w=401wt.eu-S1759553AbZD2QHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553AbZD2QHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 12:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758996AbZD2QHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 12:07:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:17360 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759415AbZD2QHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 12:07:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,266,1239001200"; 
   d="scan'208";a="452609305"
From: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
To: "Styner, Douglas W" <douglas.w.styner@intel.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Ma, Chinang" <chinang.ma@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       "Nueckel, Hubert" <hubert.nueckel@intel.com>,
       "Recalde, Luis F" <luis.f.recalde@intel.com>,
       "Nelson, Doug" <doug.nelson@intel.com>,
       "Cheng, Wu-sun" <wu-sun.cheng@intel.com>,
       "Prickett, Terry O" <terry.o.prickett@intel.com>,
       "Shunmuganathan, Rajalakshmi" <rajalakshmi.shunmuganathan@intel.com>,
       "Garg, Anil K" <anil.k.garg@intel.com>,
       "Chilukuri, Harita" <harita.chilukuri@intel.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>
Date: Wed, 29 Apr 2009 10:06:44 -0600
Subject: RE: Mainline kernel OLTP performance update
Thread-Topic: Mainline kernel OLTP performance update
Thread-Index: AcnIpH2wYNuL0nVjSjitaku5DQLCvgAPXCLwAACgmSA=
Message-ID: <CAC4B8726E86A142B27A9E9A2F2F1247AB6943CB@rrsmsx505.amr.corp.intel.com>
References: <D7C42C27E6CB1E4D8CBDF2F81EA92A2603459F3D6A@azsmsx501.amr.corp.intel.com>
	<20090429002930.b786348b.akpm@linux-foundation.org>
 <871vrbrhhy.fsf@basil.nowhere.org>
 <D7C42C27E6CB1E4D8CBDF2F81EA92A260345A63FAC@azsmsx501.amr.corp.intel.com>
In-Reply-To: <D7C42C27E6CB1E4D8CBDF2F81EA92A260345A63FAC@azsmsx501.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n3TG8Fqu015804

Is it possible that's simply 'oprofile has a 4% overhead'?

> -----Original Message-----
> From: Styner, Douglas W
> Sent: Wednesday, April 29, 2009 9:00 AM
> To: Andi Kleen; Andrew Morton
> Cc: linux-kernel@vger.kernel.org; Tripathi, Sharad C;
> arjan@linux.intel.com; Wilcox, Matthew R; Kleen, Andi; Siddha, Suresh B;
> Ma, Chinang; Wang, Peter Xihong; Nueckel, Hubert; Recalde, Luis F; Nelson,
> Doug; Cheng, Wu-sun; Prickett, Terry O; Shunmuganathan, Rajalakshmi; Garg,
> Anil K; Chilukuri, Harita; chris.mason@oracle.com
> Subject: RE: Mainline kernel OLTP performance update
> 
> What we showed was that vmstat and vtune agreed wrt system/user time.
> Oprofile is off by ~4% (4% too low for user. 4% too high for system)
> 
> >-----Original Message-----
> >From: Andi Kleen [mailto:andi@firstfloor.org]
> >Sent: Wednesday, April 29, 2009 1:28 AM
> >To: Andrew Morton
> >Cc: Styner, Douglas W; linux-kernel@vger.kernel.org; Tripathi, Sharad C;
> >arjan@linux.intel.com; Wilcox, Matthew R; Kleen, Andi; Siddha, Suresh B;
> >Ma, Chinang; Wang, Peter Xihong; Nueckel, Hubert; Recalde, Luis F;
> Nelson,
> >Doug; Cheng, Wu-sun; Prickett, Terry O; Shunmuganathan, Rajalakshmi;
> Garg,
> >Anil K; Chilukuri, Harita; chris.mason@oracle.com
> >Subject: Re: Mainline kernel OLTP performance update
> >
> >Andrew Morton <akpm@linux-foundation.org> writes:
> >
> >>> ======oprofile CPU_CLK_UNHALTED for top 30 functions
> >>> Cycles% 2.6.24.2                   Cycles% 2.6.30-rc3
> >>> 74.8578 <database>                 69.1925 <database>
> >>
> >> ouch, that's a large drop in userspace CPU occupancy.  It seems
> >> inconsistent with the 1.91% above.
> >
> >That was determined to be an oprofile artifact/regression (see Doug's
> >other email+thread) The 2.6.30 oprofile seems to be less accurate than
> >the one in 2.6.24. Of course the question is if it can't get
> >the user space right, is the kernel data accurate. But I believe
> >Doug verified with vtune that the kernel data is roughly correct,
> >just user space profiling was slightly bogus (right, Doug, or
> >do I misrepresent that?)
> >
> >-Andi
> >
> >--
> >ak@linux.intel.com -- Speaking for myself only.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
