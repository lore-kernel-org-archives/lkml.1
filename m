Return-Path: <linux-kernel-owner+w=401wt.eu-S1760082AbZFOKJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082AbZFOKJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 06:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbZFOKJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 06:09:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59090
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753264AbZFOKJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 06:09:32 -0400
Date: Mon, 15 Jun 2009 03:09:34 -0700 (PDT)
Message-Id: <20090615.030934.193678346.davem@davemloft.net>
To: tiwai@suse.de
Cc: bzolnier@gmail.com, sven.koehler@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: sound skipping regression introduced in 2.6.30-rc8
From: David Miller <davem@davemloft.net>
In-Reply-To: <s5hy6rtesjo.wl%tiwai@suse.de>
References: <s5h63exevqh.wl%tiwai@suse.de>
	<20090615.022547.107684868.davem@davemloft.net>
	<s5hy6rtesjo.wl%tiwai@suse.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>
Date: Mon, 15 Jun 2009 11:48:43 +0200

> The below is a revised patch.  It has an additional sanity check.
> Please give it a try.

This is significantly worse.

It skips many times every second.  It even skips at least once
per second with xrun_debug set to "5".

[340486.694613] intel8x0_measure_ac97_clock: measured 50109 usecs (2416 samples)
[340486.694620] intel8x0: clocking to 48000
[340542.816403] PCM: hw_ptr skipping! [Q] (pos=16280, delta=16280, period=1024, jdelta=2/33/0)
[340542.837725] PCM: hw_ptr skipping! [Q] (pos=16280, delta=16280, period=1024, jdelta=5/33/1)
[340542.859059] PCM: hw_ptr skipping! [Q] (pos=16280, delta=15256, period=1024, jdelta=2/31/0)
[340542.868179] PCM: hw_ptr skipping! (pos=16280, delta=15256, period=1024, jdelta=3/31)
[340542.869193] PCM: hw_ptr skipping! (pos=16280, delta=15256, period=1024, jdelta=3/31)
[340542.869364] PCM: hw_ptr skipping! (pos=16280, delta=15256, period=1024, jdelta=3/31)
[340542.869384] PCM: hw_ptr skipping! (pos=16280, delta=15256, period=1024, jdelta=3/31)
[340542.880392] PCM: hw_ptr skipping! [Q] (pos=16280, delta=15256, period=1024, jdelta=4/31/1)
[340542.890488] PCM: hw_ptr skipping! (pos=16280, delta=14232, period=1024, jdelta=1/29)
[340542.890508] PCM: hw_ptr skipping! (pos=16280, delta=14232, period=1024, jdelta=1/29)
