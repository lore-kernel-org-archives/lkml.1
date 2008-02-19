Return-Path: <linux-kernel-owner+w=401wt.eu-S1757729AbYBSMBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729AbYBSMBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 07:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbYBSMBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 07:01:12 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59652 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752119AbYBSMBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 07:01:11 -0500
Date: Tue, 19 Feb 2008 03:59:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Miller <mike.miller@hp.com>, LKML <linux-kernel@vger.kernel.org>,
       LKML-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/1] cciss: procfs updates to display info about many
 volumes
Message-Id: <20080219035956.d66052af.akpm@linux-foundation.org>
In-Reply-To: <20080219104818.GX23197@kernel.dk>
References: <20080211220906.GA24835@roadking.usa.hp.com>
	<20080219104818.GX23197@kernel.dk>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008 11:48:18 +0100 Jens Axboe <jens.axboe@oracle.com> wrote:

> On Mon, Feb 11 2008, Mike Miller wrote:
> > Patch 1 of 1
> > 
> > This patch allows us to display information about all of the logical volumes
> > configured on a particular without stepping on memory even when there are
> > many volumes (128 or more) configured. This patch replaces the one submitted
> > on 20071214. See
> > http://groups.google.com/group/linux.kernel/browse_thread/thread/49a50244b19f8855/ba3dc95b23391521?hl=en&lnk=gst&q=cciss#ba3dc95b23391521
> > which has not been merged. That patch displayed information about only the
> > first logical volume on each controller and had negative side effects for some
> > installers.
> > Please consider this for inclusion.
> 
> It looks ok, but has some flaws. Try to disable cciss scsi and tape
> support:
> 
> In file included from drivers/block/cciss.c:231:
> drivers/block/cciss_scsi.c:1498:38: error: macro parameters must be
> comma-separated
> drivers/block/cciss.c: In function 'cciss_seq_show_header':
> drivers/block/cciss.c:272: error: implicit declaration of function
> 'cciss_seq_tape_report'
> drivers/block/cciss.c: In function 'cciss_proc_write':
> drivers/block/cciss.c:393: error: implicit declaration of function
> 'cciss_engage_scsi'
> 
> You macro definition of cciss_seq_tape_report() is totally busted.
> Either write is as a macro OR as a function.
> 
> Fix these up and resubmit, then I'll take it.
> 

It also need to be updated to use the non-racy proc_create(),
please, as per Alexey's comments.
