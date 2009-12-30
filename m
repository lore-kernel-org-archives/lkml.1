Return-Path: <linux-kernel-owner+w=401wt.eu-S1753754AbZL3VQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbZL3VQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 16:16:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496AbZL3VQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 16:16:04 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:17376 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbZL3VQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 16:16:01 -0500
Date: Wed, 30 Dec 2009 22:15:57 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Nico <segfault2@hotmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: ksoftirqd problem
Message-ID: <20091230211555.GD6322@nowhere>
References: <BLU118-W2048C3510A781E30899013E68A0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BLU118-W2048C3510A781E30899013E68A0@phx.gbl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 13, 2009 at 08:05:29PM +0100, Nico wrote:
> 
> Hi,
> 
> I recently switched to kernel 2.6.32 (self configured/compiled) and I've noticed an odd behavior on one of my servers. I run a bittorrent tracker on one of my servers and when using kernel 2.6.32, every now and then ksoftirqd will jump up to 20% of my CPU for almost a minute. The tracker has a total peers amount of ~45000 peers (if it matters) and this behavior seems to only happen under kernel 2.6.32. Switching back to kernel 2.6.31.1 on the server, ksoftirdq does not behave that way.
> 
> Any thoughts?
> 
> PS: please CC me as I'm not subscribed to the list
> 
> Thanks :)


Hi,

I wonder if this problem still happens in 2.6.33-rc2.

A trace of softirqs during the issue would be helpful
to determine which softirq is the culprit:

mount -t debugfs /debug

echo 1 > /debug/tracing/events/irq/softirq_entry/enable
# wait a bit 
echo 0 > /debug/tracing/events/irq/softirq_entry/enable

cat trace

Thanks.

