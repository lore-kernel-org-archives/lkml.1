Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbYAIQC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbYAIQC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 11:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbYAIQCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 11:02:21 -0500
Received: from mail.daysofwonder.com ([213.186.49.53]:50963 "EHLO
	mail.daysofwonder.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbYAIQCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 11:02:20 -0500
Subject: Re: Strange freeze on 2.6.22 (deadlock?)
From: Brice Figureau <brice+lklm@daysofwonder.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4784046B.5000004@redhat.com>
References: <49447.213.41.177.193.1199732765.squirrel@corp.daysofwonder.com>
	 <4784046B.5000004@redhat.com>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 17:02:14 +0100
Message-Id: <1199894534.7626.75.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2008-01-08 at 18:16 -0500, Chuck Ebbert wrote: 
> On 01/07/2008 02:06 PM, Brice Figureau wrote:
>  
> > Thanks for the answer.
> > I'm using whatever is the default mount option (which I think is
> > data=ordered). The only other mount option I use is nodiratime,noatime.
> > 
> > Note that a large part of the processes in D state are "waiting" in
> > __mutex_lock from generic_file_aio_write.
> > Another large part is coming from balance_dirty_pages_ratelimited_nr.
> > 
> > It seems that there was some writeback congestion to the block device.
> > All the /proc/sys/vm/* files are at their defaults.
> > 
> > This looks like if it wasn't possible to write to the block device anymore.
> > Could a block device write error (ie hardware failure) be the root cause?
> > 
> > Any other idea?
> > What should I try the next time it freezes?
> 
> Same bug as http://lkml.org/lkml/2007/8/1/469 ??

Some of the stacktrace of the OP looks like the ones I posted.
The timeframe also matches since I noticed the first problems in 2.6.19
like the OP.

I remounted the fs without noatime and we'll see if it still freezes
next week.

Unfortunately, there doesn't seem to be any bug fix for this problem yet
(except the upcoming per device write throttling patch).

Thanks for pointing me in this direction,
-- 
Brice Figureau <brice+lklm@daysofwonder.com>

