Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbXFXTeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbXFXTeP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 15:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbXFXTeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 15:34:01 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54137 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752332AbXFXTeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 15:34:00 -0400
Date: Sun, 24 Jun 2007 12:33:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Patrick Mau <mau@oscar.ping.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] Adjust queue unplugging and congestion limits
Message-Id: <20070624123350.edf433bc.akpm@linux-foundation.org>
In-Reply-To: <20070624172722.GA865@oscar.prima.de>
References: <20070624172722.GA865@oscar.prima.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jun 2007 19:27:23 +0200 Patrick Mau <mau@oscar.ping.de> wrote:

> Good afternoon
> 
> Following is a small patch to "ll_rw_block" I played around with.
> I started using "blktrace" to analyse the performance of my dated
> LVM / MD / SCSI setup. It's really a nice tool, by the way.
> 
> The changes are:
> 
> * Change the "q->unplug_thresh" to be halve of "q->nr_requets".
>   This dynamically delays unplugging. It was hardcoded to 4 and
>   makes a difference in performace because of higher merge counts.
> 
> * Change the unplug timeout to 10 milliseconds.
>   This is of course questionable, but I don't know why 3 was
>   choosen in the first place. I just played with it.
> 
> * Set the congestion on/off limits further apart.
> 
> * Cleanup the congestion checks (no "+1" anymore, more readable).
> 
> * Update "q->unplug_thresh" whenever "q->nr_requests" is updated
>   through sysfs.

I don't think anyone has played with these settings since they first went
in and yes, there may be some benefits available here.

> I did various artifical benchmarksi, mostly tar, dd and cp (also to NFS).
> Comments are welcome.

umm, what was the result of this benchmarking?  That is rather important
information ;)

