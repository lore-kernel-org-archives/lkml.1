Return-Path: <linux-kernel-owner+w=401wt.eu-S1757019AbZLWUYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019AbZLWUYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 15:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbZLWUYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 15:24:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:64521 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbZLWUYc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 15:24:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,444,1257148800"; 
   d="scan'208";a="478723061"
From: "Smith, GeoffX" <geoffx.smith@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Michael Stone <michael@laptop.org>,
       Arjan van de Ven <arjan@infradead.org>
Date: Wed, 23 Dec 2009 12:24:30 -0800
Subject: RE: [PATCH] prctl: return MCE process flags through pointer
Thread-Topic: [PATCH] prctl: return MCE process flags through pointer
Thread-Index: AcqEAXPQqwLqUC6kS2uBv/ipkNn1wwAAqDrQ
Message-ID: <354B2877CF17F44BB3FA44EB4DB0E5470C91CE18ED@orsmsx510.amr.corp.intel.com>
References: <354B2877CF17F44BB3FA44EB4DB0E5470C91CE1829@orsmsx510.amr.corp.intel.com>
	<87hbricwz8.fsf@basil.nowhere.org>
	<20091222173424.980d5d33.akpm@linux-foundation.org>
	<20091223095223.GB20539@basil.fritz.box>
	<20091223021807.abbd993e.akpm@linux-foundation.org>
	<354B2877CF17F44BB3FA44EB4DB0E5470C91CE18A8@orsmsx510.amr.corp.intel.com>
 <20091223105450.8f15db9f.akpm@linux-foundation.org>
In-Reply-To: <20091223105450.8f15db9f.akpm@linux-foundation.org>
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

Earlier today, Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> >Why are task_struct.timer_slack_ns and
>> >task_struct.default_timer_slack_ns unsigned long, btw?  AFACIT we could
>> >make them unsigned ints.
>>
>> Timer slack is not a Boolean or enum, and we want the greatest range
>possible.  (Actually, I'd like to talk Arjan into using the same time
>structure as select(), but that's another discussion.) Internally hrtimer
>uses unsigned long.  I know long and unsigned long are the same on some
>architectures, but let's not introduce an unnatural restriction -- recall
>that arg2 is unsigned long.
>
>Using unsigned ints will reduce the size of the task_struct.
>
>Is there any conceivable case for a timer_slack which exceeds four
>seconds?  If so, what is it, and if so, why this:
>
>#define MAX_SLACK       (100 * NSEC_PER_MSEC)
>
>

WRT to times longer than 4.2 sec -- So far my works suggests there is a good case, but it's moot because that is all I get with unsigned long on my platform.  (Both int and long are 32-bit for me; x86)

WRT MAX_SLACK, select() always imposes a little slack (for non-real-time threads).  The name MAX_SLACK is not actually the absolute maximum, it is only the maximum that the kernel will impose by default. 

