Return-Path: <linux-kernel-owner+w=401wt.eu-S1759855AbYGKUHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759855AbYGKUHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbYGKUH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:07:27 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:24804 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759467AbYGKUHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:07:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=r84OlPTb52yDJONEGp9DYEQAgDfjMv8D6HQkvUkrv+Gxt2DkAq8K0jOZSUMoGS4uF/
         kbbVlVhWMJBx6vgeMer1drJOCncDSFQ48aKflcDKQXcz9kLAPDyS6hKDD60wOxfhq4W+
         /MQbrdQEELmBb+IJx0ialJy9PDQ163D4/uoig=
Message-ID: <e9c3a7c20807111307q1b7c4ed0wb2864e2dae6abe90@mail.gmail.com>
Date: Fri, 11 Jul 2008 13:07:24 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Maciej Sosnowski" <maciej.sosnowski@intel.com>
Subject: Re: [PATCH 1/2] I/OAT: Add watchdog/reset functionality to ioatdma driver
Cc: shannon.nelson@intel.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080711113646.337.14164.stgit@linux.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080711113553.337.50006.stgit@linux.site>
	 <20080711113646.337.14164.stgit@linux.site>
X-Google-Sender-Auth: 810f4cd2ad202051
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 4:36 AM, Maciej Sosnowski
<maciej.sosnowski@intel.com> wrote:
> Due to occasional DMA channel hangs observed for I/OAT versions 1.2 and 2.0
> a watchdog has been introduced to check every 2 seconds
> if all channels progress normally.
> If stuck channel is detected, driver resets it.
> The reset is done in two parts. The second part is scheduled
> by the first one to reinitialize the channel after the restart.
>

checkpatch had some valid suggestions, please give it a run.

A general comment about this change it seems to add a bit of
complexity.  The driver now has two workqueue routines and a tasklet.
Might some of these be combined?  In other words, do we need a free
running watchdog when no descriptors are in flight?  It seems that
using a timer to kick the cleanup tasklet could be used in place of
the ioat_dma_chan_watchdog workqueue.

> Sleep time in self_test has been increased to 10ms
> since in some cases 1ms appeared not to be enough.

This should be broken out into a separate patch.  Perhaps with an
explanation of why it needs extra time for this particular
transaction.

Regards,
Dan
