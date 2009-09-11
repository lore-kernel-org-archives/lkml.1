Return-Path: <linux-kernel-owner+w=401wt.eu-S1752824AbZIKAUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbZIKAUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 20:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbZIKAUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 20:20:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbZIKAUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 20:20:04 -0400
Date: Thu, 10 Sep 2009 20:19:32 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, samba@lists.samba.org,
       linux-cifs-client@lists.samba.org
Subject: Re: 2.6.31-rc8: CIFS with 5 seconds hiccups
Message-ID: <20090910201932.5b8356e2@tlielax.poochiereds.net>
In-Reply-To: <alpine.DEB.1.10.0909101721180.27669@V090114053VZO-1>
References: <alpine.DEB.1.10.0909041217520.7209@V090114053VZO-1>
	<20090905071052.50501826@tlielax.poochiereds.net>
	<alpine.DEB.1.10.0909091009120.28070@V090114053VZO-1>
	<20090909125352.1c7b57d2@tlielax.poochiereds.net>
	<alpine.DEB.1.10.0909091304001.32067@V090114053VZO-1>
	<20090909132039.1ca47cd4@tlielax.poochiereds.net>
	<alpine.DEB.1.10.0909091327370.32067@V090114053VZO-1>
	<20090909140257.35ede0cc@tlielax.poochiereds.net>
	<alpine.DEB.1.10.0909091724200.15746@V090114053VZO-1>
	<20090909205548.4858b524@zanovar.poochiereds.net>
	<alpine.DEB.1.10.0909101419310.29762@V090114053VZO-1>
	<20090910153347.2f2616e8@barsoom.rdu.redhat.com>
	<alpine.DEB.1.10.0909101541460.28418@V090114053VZO-1>
	<20090910165757.43b77874@tlielax.poochiereds.net>
	<alpine.DEB.1.10.0909101721180.27669@V090114053VZO-1>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Sep 2009 17:27:53 -0400 (EDT)
Christoph Lameter <cl@linux-foundation.org> wrote:

> Right. 32 bit cannot mount the clameter directory for strange reasons. I
> have to go one level higher.
[...]
> One other issue that may be important: The mounting operation is very slow
> on 32 bit. Could it be that the handshake does not work out?

Ok, looks like the 64 bit client is using a different level of interest
than the 32 bit on the FIND_FIRST call. I suspect that that difference
may account for the difference in response time.

It's not completely clear to me why that would be. Maybe a windows bug
that causes a slowdown with that LOI?

In any case, I think we need to look closely at what's happening at
mount time. First, I'll need some other info:

1) output of "/sbin/mount.cifs -V" from both machines

2) mount options that you're using on both boxes

3) wire captures from mount attempts on both machines. Try to mount the
"clameter" dir on both boxes and do captures of each attempt. Maybe
this time use -s 0 with tcpdump so we get all of the traffic.

There may be crackable password hashes in the captures, so you may want
to send them to me privately and not cc the list.

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>
