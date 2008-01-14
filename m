Return-Path: <linux-kernel-owner+w=401wt.eu-S1751871AbYANTIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871AbYANTIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:08:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750744AbYANTHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:07:55 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:4421 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbYANTHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:07:54 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett Packard
To: Valdis.Kletnieks@vt.edu
Subject: Re: 2.6.24-rc6-mm1 - oddness with IPv4/v6 mapped sockets hanging...
Date: Mon, 14 Jan 2008 14:07:46 -0500
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
References: <30887.1200209733@turing-police.cc.vt.edu> <32065.1200334930@turing-police.cc.vt.edu> <1030.1200336639@turing-police.cc.vt.edu>
In-Reply-To: <1030.1200336639@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801141407.46345.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 January 2008 1:50:39 pm Valdis.Kletnieks@vt.edu wrote:
> On Mon, 14 Jan 2008 13:22:10 EST, Valdis.Kletnieks@vt.edu said:
> > Apparently the only new commit in there since the tree that was in
> > 24-rc6-mm1 is 5d95575903fd3865b884952bd93c339d48725c33 adding some
> > warning printk's.  Would it be more productive to test against the full
> > tree, or leaving out the one commit I already reverted?
>
> <voice=Emily Litella> Nevermind... </voice> :)
>
> The new commit won't apply with the other one reverted - it patches
> security/selinux/netnode.c which was created by the problematic commit...

There have been quite a few changes in lblnet-2.6_testing since 2.6.24-rc6-mm1 
so I would recommend taking the whole tree.  I'm also not quite sure if 
simply reverting the "Convert the netif code to use ifindex values" patch 
would solve the problem as there are other patches in the rc6-mm1 tree that 
rely on skb->iif being valid (new code, not converted code).  If you want to 
stick with a _relatively_ vanilla rc6-mm1 tree I would leave everything in 
and simply apply the following patch which solved the skb_clone()/iif 
problem:

http://git.infradead.org/?p=users/pcmoore/lblnet-2.6_testing;a=commitdiff;h=02f1c89d6e36507476f78108a3dcc78538be460b

-- 
paul moore
linux security @ hp
