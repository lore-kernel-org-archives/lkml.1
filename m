Return-Path: <linux-kernel-owner+w=401wt.eu-S1758774AbYF3XM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774AbYF3XM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 19:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbYF3XMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 19:12:47 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35709 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130AbYF3XMr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 19:12:47 -0400
From: "Woodruff, Richard" <r-woodruff2@ti.com>
To: Len Brown <lenb@kernel.org>,
       Linux Power Management List <linux-pm@lists.osdl.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 30 Jun 2008 18:11:52 -0500
Subject: RE: [linux-pm] Linux Power Management Mini-Summit -- Ottawa -- July
 22,	2008
Thread-Topic: [linux-pm] Linux Power Management Mini-Summit -- Ottawa --
 July 22,	2008
Thread-Index: AcjW9WDChl0pE2miSS+3McPoUveWbwEDfrdw
Message-ID: <13B9B4C6EF24D648824FF11BE8967162035BBF861D@dlee02.ent.ti.com>
References: <alpine.LFD.1.10.0806251358060.3014@localhost.localdomain>
In-Reply-To: <alpine.LFD.1.10.0806251358060.3014@localhost.localdomain>
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

> Send suggestions for topics to linux-pm@lists.osdl.org,
> whether you plan to attend or not.  The attendees will
> form the agenda by consensus at the start of the session.
>
> If you would like to attend, please send a note to
> linux-pm@lists.osdl.org announcing your intent,
> and what you would like to discuss.

I would like to attend.

Main topics of interest would be run time PM.

We currently have ARM systems using cpuidle and going to 0v with full context loss between dynamic ticks.  There are a few areas it would be nice to get feed back on some hacks have had to be employed to get reasonable performance.

For example:
- we are saving driver state based on aggressive clock disables in drivers and only restoring context back on enable on control or event paths.  Doing this at the bottom of a driver stack like MMC means you don't always have good knowledge of what the stack has in store.  As such we add some activity timers to smooth it out.  But it would be nice to have some kind of idea about upper layer activity.

- With dynamic tick running you find needless one shot timer reprogramming (mainly from high interrupts during idle).  This can overflow the timer posting buffer and stall the MPU to a slower clock domain.  This results in really bad throughput.  Just keeping user space active and the periodic timer running instead of 1-shot will result in much better performance.

- How to account for demoted C-States?  Right now if a CPUIDLE BM check forces a state reduction compared to the menu governor chosen C-State there is no path to allow for residency accounting for the actual state entered.

Thanks,
Richard W.

