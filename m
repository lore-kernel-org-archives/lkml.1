Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbZG3We5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbZG3We5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 18:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbZG3We4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 18:34:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751570AbZG3We4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 18:34:56 -0400
Date: Thu, 30 Jul 2009 15:34:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Fertser <fercerpav@gmail.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pcf50633: use a dedicated workqueue for irq processing
Message-Id: <20090730153425.9a3fc5ac.akpm@linux-foundation.org>
In-Reply-To: <200907281845.n6SIjIlf025081@home.pavel.comp>
References: <200907281845.n6SIjIlf025081@home.pavel.comp>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jul 2009 00:41:15 +0400
Paul Fertser <fercerpav@gmail.com> wrote:

> Using the default kernel "events" workqueue causes problems with
> synchronous adc readings if initiated from some task on the same
> workqueue.
> 
> I had a deadlock trying to use pcf50633_adc_sync_read from a
> power_supply class driver because the reading was initiated from the
> workqueue and it waited for the irq processing to complete (to get the
> result) and that was put on the same workqueue.

I don't get it.

Do you meant that pcf50633_adc_sync_read() was called via a
schedule_work() handler?  If so, wasn't that a bug?

The patch looks reasonable, but creating yet another kernel thread is a
bit sad.  And I suspect that other MFD drivers are doing the same thing
as pcf50633-core.c, in which case we should change those as well?

So..  please provide a more complete description of the problem which
is being solved so that we can explore alternative fixes.

