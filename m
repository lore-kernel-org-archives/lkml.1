Return-Path: <linux-kernel-owner+w=401wt.eu-S1422725AbXCBCxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422725AbXCBCxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 21:53:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422721AbXCBCxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 21:53:06 -0500
Received: from 206-72-67-168.dsl.dock.net ([206.72.67.168]:60715 "EHLO
	elektro.pacujo.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422725AbXCBCxF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 21:53:05 -0500
X-Greylist: delayed 1099 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Mar 2007 21:53:05 EST
To: linux-kernel@vger.kernel.org
Subject: Is the clockevent resolution fine-grained enough?
Date: 01 Mar 2007 18:34:44 -0800
Message-ID: <m3649kweyj.fsf@elektro.pacujo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
From: Marko Rauhamaa <marko@pacujo.net>
X-Delivery-Agent: TMDA/1.0.3 (Seattle Slew)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It would appear the new clockevent API has a one-nanosecond resolution.
It certainly looks sufficiently fine-grained, but I'm afraid it's too
coarse for some applications.

In our application, we need periodic clock interrupts at about 100 kHz.
If the (programmable) frequency must be rounded to the nearest
nanosecond, we have a cumulative error of

   100,000 * 0.5 ns/s = 50 µs/s

We need to maintain the cumulative error within, say, 1 ms/day, or
11 ns/s. (The error is not measured against real time, but between
different parts of our hardware that are run off of the same clock.)

For our needs, we have built our own "clockevent" system that has a
nominal one-femtosecond precision. The nanosecond resolution would be
sufficient if there was a way to "nudge" the next interrupt by a
nanosecond from the interrupt handler.


Marko

-- 
Marko Rauhamaa      mailto:marko@pacujo.net     http://pacujo.net/marko/
