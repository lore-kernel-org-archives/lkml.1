Return-Path: <linux-kernel-owner+w=401wt.eu-S1754347AbZBCEFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbZBCEFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 23:05:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbZBCEFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 23:05:20 -0500
Received: from avexch1.qlogic.com ([198.70.193.115]:45835 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZBCEFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 23:05:18 -0500
Date: Mon, 2 Feb 2009 20:05:16 -0800
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "matthew@wil.cx" <matthew@wil.cx>, "gregkh@suse.de" <gregkh@suse.de>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: slab error in verify_redzone_free() badness...
Message-ID: <20090203040516.GA11835@plap4-2.local>
References: <20090129225532.GA37589@plap4-2.local> <20090202151852.de39952b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090202151852.de39952b.akpm@linux-foundation.org>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 03 Feb 2009 04:04:16.0044 (UTC) FILETIME=[7AF7D6C0:01C985B4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Feb 2009, Andrew Morton wrote:

> I'd be suspecting a bug in the caller.
> 
> Try setting CONFIG_DEBUG_PAGEALLOC, and use slab.c (not slub).  slab
> will perform page unmapping for those 2k-sized slabs.  I don't know
> whether slub does that.
> 
> All being well, you'll get a nice oops at the site of the improper
> reference.

Thanks for the tip...  Yeah, we're triaging this further, as it seems
to be pointing to something in the recent 'refactoring/multi-q' code
in qla2xxx...

--
av
