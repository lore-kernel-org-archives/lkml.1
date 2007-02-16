Return-Path: <linux-kernel-owner+w=401wt.eu-S1946064AbXBPTAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946064AbXBPTAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 14:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946050AbXBPTAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 14:00:43 -0500
Received: from 207.47.60.150.static.nextweb.net ([207.47.60.150]:44350 "EHLO
	webmail.xensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946064AbXBPTAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 14:00:42 -0500
User-Agent: Microsoft-Entourage/11.2.5.060620
Date: Fri, 16 Feb 2007 19:00:39 +0000
Subject: Re: [Xen-devel] Re: [patch 14/21] Xen-paravirt: Add XEN config
 options and disableunsupported config options.
From: Keir Fraser <keir@xensource.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Keir Fraser <keir@xensource.com>
CC: <xen-devel@lists.xensource.com>, Andi Kleen <ak@muc.de>,
       <linux-kernel@vger.kernel.org>, Ian Pratt <Ian.Pratt@xensource.com>,
       Chris Wright <chrisw@sous-sol.org>, <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Hand <steven.hand@cl.cam.ac.uk>,
       Christian Limpach <Christian.Limpach@xensource.com>
Message-ID: <C1FBAFD7.99AB%keir@xensource.com>
Thread-Topic: [Xen-devel] Re: [patch 14/21] Xen-paravirt: Add XEN config
 options and disableunsupported config options.
Thread-Index: AcdR/L+D/d7q+L3vEduRUwAX8io7RQ==
In-Reply-To: <45D5EDDB.7050404@goop.org>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/2/07 17:46, "Jeremy Fitzhardinge" <jeremy@goop.org> wrote:

> Keir Fraser wrote:
>> This initial patchset does not include save/restore support anyway, so in
>> fact it would be consistent to have CONFIG_PREEMPT configurable. I'm sure
>> that we are going to have some nasty bugs to fix up as a result, but we
>> can't fix them until we find them! Then we can convert our save/restore code
>> to use the freezer before submitting it for inclusion.
> OK.  So that makes the only config restriction the 100Hz ticks.

We can extend the Xen timer interface quite easily and get rid of this one
too. In fact it doesn't *much* matter if the CONFIG_HZ differs from the Xen
ticker rate -- we modified the Linux timer ISR to handle timer interrupts at
arbitrary times already. The only drawback is that jiffies updates in burts
if CONFIG_HZ is higher than the actual tick rate, and this can affect some
calibration constants and cause Linux to print out some weird values at
start-of-day.

 -- Keir

