Return-Path: <linux-kernel-owner+w=401wt.eu-S933103AbXCRUdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933103AbXCRUdG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 16:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933196AbXCRUdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 16:33:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:23331 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933103AbXCRUdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 16:33:04 -0400
Date: Sun, 18 Mar 2007 22:33:45 +0200
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, general@lists.openfabrics.org,
       Roland Dreier <rolandd@cisco.com>
Subject: Re: dst_ifdown breaks infiniband?
Message-ID: <20070318203345.GF11078@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <20070318155532.GG7958@mellanox.co.il>
	<20070318191238.GA20518@ms2.inr.ac.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070318191238.GA20518@ms2.inr.ac.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>:
Subject: Re: dst_ifdown breaks infiniband?
> > Can dst->neighbour be changed to point to NULL instead, and the neighbour
> > released?
> 
> It should be cleared and we should be sure it will not be destroyed
> before quiescent state.
> 
> Seems, this is the only correct solution, but to do this we have
> to audit all the places where dst->neighbour is dereferenced for
> RCU safety.
> 
> Actually, it is very good you caught this eventually, the bug was
> so _disgusting_ that it was "forgotten" all the time, waiting for
> someone who will point out that the king is naked. :-)

Actually that might not be too bad:
$grep -rIi 'dst->neighbour' net/ | wc -l
36

I'll try to do it.

-- 
MST
