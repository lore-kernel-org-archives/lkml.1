Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbZCUKKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbZCUKKB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 06:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbZCUKJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 06:09:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754492AbZCUKJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 06:09:48 -0400
Date: Sat, 21 Mar 2009 03:03:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: forbid to re-enable I/O stat accounting
Message-Id: <20090321030309.f783ec8c.akpm@linux-foundation.org>
In-Reply-To: <200903201333.n2KDXONh023780@dhcp-0-152.brq.redhat.com>
References: <200903201333.n2KDXONh023780@dhcp-0-152.brq.redhat.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please fix your email headers - what I received was

From: Jerome Marchand <jmarchan@redhat.com>
To: unlisted-recipients:;;@imap1.linux-foundation.org (no To-header on input)
Cc: Jens Axboe <axboe@kernel.dk>


On Thu, 19 Mar 2009 11:36:50 +0100 Jerome Marchand <jmarchan@redhat.com> wrote:

> When we stop I/O stat accounting we stop to update the in-flight
> requests counter and we need this counter to be reliable for
> accounting I/O stats. Unfortunately updating in_flight field may
> affect performance. So, until we have a better solution, just forbid
> to re-enable I/O stat accounting after it has been disabled.

hm.  Is it really so hard to just quiesce the device until all in-flight
requests have drained?  freeze_bdev() might be a suitable starting point?

