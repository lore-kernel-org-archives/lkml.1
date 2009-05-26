Return-Path: <linux-kernel-owner+w=401wt.eu-S1758311AbZEZVxC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311AbZEZVxC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:53:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757131AbZEZVwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:52:53 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40046 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755563AbZEZVww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:52:52 -0400
Date: Tue, 26 May 2009 17:52:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Arjan van de Ven <arjan@linux.intel.com>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Bug in SCSI async probing
In-Reply-To: <1243373019.2815.83.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0905261741430.11998-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009, James Bottomley wrote:

> > Also, I do still think that wait_scan_init() needs an extra call to 
> > async_synchronize_full() at the end.
> 
> I need to understand it before commenting ... I'm slowly working my way
> through the async patches.

There are two lists of queued asynchronous tasks: Arjan's list and the
SCSI scanning list.  As things stand now, routines in each list are
capable of submitting new jobs for the other list.  That is, an async
task may discover and register a new SCSI host (requiring scanning),
and the probe of a SCSI disk discovered during scanning will submit
a sd_probe_async task.

This makes it difficult to wait for both lists to become idle.  Maybe 
the whole idea behind scsi_wait_scan.c needs some rethinking...

Alan Stern

