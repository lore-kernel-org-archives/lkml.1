Return-Path: <linux-kernel-owner+w=401wt.eu-S1753034AbZHXR2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbZHXR2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 13:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbZHXR2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 13:28:37 -0400
Received: from stinky.trash.net ([213.144.137.162]:56840 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbZHXR2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 13:28:36 -0400
Message-ID: <4A92CDC5.2060707@trash.net>
Date: Mon, 24 Aug 2009 19:28:37 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Maximilian Engelhardt <maxi@daemonizer.de>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: Re: Logic for SNAT persistent handling introduced in 2.6.30 is inverted
References: <200908241516.16544.maxi@daemonizer.de>
In-Reply-To: <200908241516.16544.maxi@daemonizer.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maximilian Engelhardt wrote:
> Kernel 2.6.30 introduced a patch [1] for the persistent option in the 
> netfilter SNAT target. This is exactly what we need here so I had a quick look 
> at the code and noticed that the patch is wrong. The logic is simply inverted.
> The patch below fixes this.

Good catch, applied. I'm wondering what the people who requested and
tested this change did actually test :)

> Also note that because of this the default behavior of the SNAT target has 
> changed since kernel 2.6.30 as it now ignores the destination IP in choosing 
> the source IP for nating (which should only be the case if the persistent 
> option is set).

It fortunately only affects NAT to a range of IPs, which isn't
used that much.
