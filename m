Return-Path: <linux-kernel-owner+w=401wt.eu-S1753662AbZIJTdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbZIJTdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 15:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbZIJTdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 15:33:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbZIJTdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 15:33:49 -0400
Date: Thu, 10 Sep 2009 15:33:47 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, samba@lists.samba.org,
       linux-cifs-client@lists.samba.org
Subject: Re: 2.6.31-rc8: CIFS with 5 seconds hiccups
Message-ID: <20090910153347.2f2616e8@barsoom.rdu.redhat.com>
In-Reply-To: <alpine.DEB.1.10.0909101419310.29762@V090114053VZO-1>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Sep 2009 14:53:12 -0400 (EDT)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Wed, 9 Sep 2009, Jeff Layton wrote:
> 
> > Well, I can see the delays in the capture, but the snarflen for the
> > capture is a little too small to tell much else. Can you redo the
> > capture with a larger snarflen (maybe -s 512 or so)?
> 
> -s 1000 version attached.
> 
> > Also, were you able to tell anything from a server-side capture? Is the
> > server issuing oplock breaks at those times?
> 
> Thats a pretty busy system. They have not gotten around to do any logging
> on that end.

Ok. I had a look at the capture. The stalls seem to be occurring on
FIND_FILE requests. Those are similar to READDIRPLUS requests in NFS,
it returns a list of files that match a particular set of criteria and
their attributes.

Each time the client is making one of these calls to the server, it
requests a set of up to 150 files. The server grinds for 5s each time
and then responds.

The calls themselves seem to be sane AFAICT. I don't see any problems
with the parameters we're sending for the search. I also had a look
over the FIND_FIRST code and it doesn't seem to have any obvious
word size related problems.

I assume that the 32 and 64 bit clients you have are calling "ls" in
the same dir. If so, maybe a similar capture from a 64-bit client might
help us see the difference?

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>
