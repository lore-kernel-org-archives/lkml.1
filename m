Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbYCCRfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbYCCRfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:35:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761161AbYCCRSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:18:15 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44959 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760009AbYCCRSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:18:13 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47CC326D.3070604@s5r6.in-berlin.de>
Date: Mon, 03 Mar 2008 18:16:29 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>
CC: linux1394-devel@lists.sourceforge.net, Jarod Wilson <jwilson@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] firewire: fix crash in automatic module unloading
References: <tkrat.5dc141579386d159@s5r6.in-berlin.de>	 <tkrat.ce9862ad477be41e@s5r6.in-berlin.de> <59ad55d30803030845n419ac813kaa99e5ee7657dc52@mail.gmail.com>
In-Reply-To: <59ad55d30803030845n419ac813kaa99e5ee7657dc52@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kristian Høgsberg wrote:
> I would want to use a kref and a completion for tracking this though
> instead of the atomic.  Just use kref_get() instead of incrementing
> the atomic and use kref_put() instead of decrementing it.  The release
> function for kref_put() should complete the completion struct and
> instead of the busy loop in fw_core_remove_card() we just wait for the
> completion.

Sounds like the way to go.  Since I already passed that patch upwards, I 
will do an incremental rework.  (But perhaps not before spending some 
time on ticket number 9617 at bugzilla.kernel.org's...)

> And I'm not sure I agree that it's a device_count, it
> really just is a ref-count.  The core should also hold a reference to
> the card and release it in fw_core_remove_card(), just before waiting
> on the completion.

Right; we just shouldn't mix fw-ohci's refcounting (which isn't really 
needed since the lifetime rules for the card are as simple as they can 
get for fw-ohci) and fw-core's refcounting.
-- 
Stefan Richter
-=====-==--- --== ---==
http://arcgraph.de/sr/
