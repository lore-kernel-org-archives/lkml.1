Return-Path: <linux-kernel-owner+w=401wt.eu-S1759056AbXERPql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759056AbXERPql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 11:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbXERPqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 11:46:34 -0400
Received: from mail.gmx.net ([213.165.64.20]:35774 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754356AbXERPqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 11:46:34 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX18XKfoQYhsXyZSsWPPRg5LTNjQ81CvEFHNJH6f3hx
	0IQFye7w7uxZCa
Date: Fri, 18 May 2007 17:46:29 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: tglx@linutronix.de
Cc: mingo@elte.hu, yi.zhu@intel.com, linux-kernel@vger.kernel.org,
       arjan@infradead.org
Subject: Increased ipw2200 power usage with dynticks
Message-ID: <20070518154629.GA27105@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	tglx@linutronix.de, mingo@elte.hu, yi.zhu@intel.com,
	linux-kernel@vger.kernel.org, arjan@infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while playing around with powertop, I noticed that my power usage wasn't
what it used to be. In total idle mode, everything was fine, but as soon
as I loaded the ipw2200 module and bring up the device, power usage
rises to about 16.8W, while kernel up to 2.6.20 used only about 15.3W. A
day worth of bisecting later, I could put my finger on dynticks, tested
2.6.22-rc1 without dynticks and power usage was at least down to about
15.5-15.6W, not perfect, but a lot better.

It seems that ipw2200 wants to do something about its power usage, but
dynticks stops it from doing so, as holding down the "Fn" key, and
thereby generating about 60 additional wakeups per second, brings the
power usage down to about the same as in the non-dynticks case.

Powertop also revealed, that with dynticks, my CPU is spending 99% in C2
when the power usage is high, but about 50% in C3 when I hold down "Fn".

Let me know if you need further details.

Thanks,
Björn
