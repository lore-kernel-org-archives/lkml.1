Return-Path: <linux-kernel-owner+w=401wt.eu-S933291AbXAaO14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291AbXAaO14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 09:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933294AbXAaO14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 09:27:56 -0500
Received: from smtp1-g19.free.fr ([212.27.42.27]:47850 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933291AbXAaO1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 09:27:55 -0500
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: Simon Arlott <3d1f88d2534993eb311hc0vm0003uvpw@thunder.lp0.eu>
Subject: Re: [PATCH 2/3] cxacru: Poll for device status more frequently.
Date: Wed, 31 Jan 2007 15:27:36 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <45BFB841.9030200@simon.arlott.org.uk>
In-Reply-To: <45BFB841.9030200@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701311527.39343.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The device is only polled for status every 5 seconds yet status updates
> occur as often as every second - when the line is down the status changes
> between "down" and "attempting to activate" every 2 seconds.  

How much overhead does polling involve?  [A particularly problematic case
is when polling is failing - I've occasionally seen speedtouch modems
where polling fails every time (not sure why) and for some reason this
increases system load considerably, which is why the speedtch driver has
a dynamic polling interval].  If polling overhead is basically nothing,
then this change is OK with me.  Otherwise the next simplest thing to do
is to have a short polling interval when the line is down, and a longer
one when the line is up.

Ciao,

Duncan.
