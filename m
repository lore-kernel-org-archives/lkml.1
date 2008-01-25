Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbYAYUYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbYAYUYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 15:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759752AbYAYUYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 15:24:06 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:61457 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759615AbYAYUX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 15:23:59 -0500
Date: Thu, 24 Jan 2008 23:47:39 -0700
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] ext3: per-process soft-syncing data=ordered mode
In-reply-to: <200801242336.00340.a1426z@gawab.com>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Mail-followup-to: Al Boldi <a1426z@gawab.com>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-id: <20080125064739.GS18433@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <200801242336.00340.a1426z@gawab.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 24, 2008  23:36 +0300, Al Boldi wrote:
> data=ordered mode has proven reliable over the years, and it does this by 
> ordering filedata flushes before metadata flushes.  But this sometimes 
> causes contention in the order of a 10x slowdown for certain apps, either 
> due to the misuse of fsync or due to inherent behaviour like db's, as well 
> as inherent starvation issues exposed by the data=ordered mode.
> 
> data=writeback mode alleviates data=order mode slowdowns, but only works 
> per-mount and is too dangerous to run as a default mode.
> 
> This RFC proposes to introduce a tunable which allows to disable fsync and 
> changes ordered into writeback writeout on a per-process basis like this:
> 
>       echo 1 > /proc/`pidof process`/softsync

If fsync performance is an issue for you, run the filesystem in data=journal
mode, put the journal on a separate disk and make it big enough that you
don't block on it to flush the data to the filesystem (but not so big that
it is consuming all of your RAM).

That keeps your data guarantees without hurting performance.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

