Return-Path: <linux-kernel-owner+w=401wt.eu-S1754241AbYANThy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbYANThy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbYANThn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:37:43 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:37621 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbYANThm (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:37:42 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Paul Moore <paul.moore@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.24-rc6-mm1 - oddness with IPv4/v6 mapped sockets hanging...
In-Reply-To: Your message of "Mon, 14 Jan 2008 14:07:46 EST."
             <200801141407.46345.paul.moore@hp.com>
From: Valdis.Kletnieks@vt.edu
References: <30887.1200209733@turing-police.cc.vt.edu> <32065.1200334930@turing-police.cc.vt.edu> <1030.1200336639@turing-police.cc.vt.edu>
            <200801141407.46345.paul.moore@hp.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1200339422_3045P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 14 Jan 2008 14:37:02 -0500
Message-ID: <3727.1200339422@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1200339422_3045P
Content-Type: text/plain; charset=us-ascii

On Mon, 14 Jan 2008 14:07:46 EST, Paul Moore said:
> There have been quite a few changes in lblnet-2.6_testing since 2.6.24-rc6-mm1 
> so I would recommend taking the whole tree.  I'm also not quite sure if

Weird.  I did a 'git clone git://git.infradead.org/users/pcmoore/lblnet-2.6_testing'
into a new directory this morning, and doing a 'git log' against that only
showed the one added commit:

commit 5d95575903fd3865b884952bd93c339d48725c33
Author: Paul Moore <paul.moore@hp.com>
Date:   Wed Jan 9 15:30:23 2008 -0500

    SELinux: Add warning messages on network denial due to error
    
    Currently network traffic can be sliently dropped due to non-avc errors which
    can lead to much confusion when trying to debug the problem.  This patch adds
    warning messages so that when these events occur there is a user visible
    notification.
    
    Signed-off-by: Paul Moore <paul.moore@hp.com>

commit 9259ca5fd8b9fbdd2c3edade593dead905d8391e
Author: Paul Moore <paul.moore@hp.com>
Date:   Wed Jan 9 15:30:23 2008 -0500

    SELinux: Add network ingress and egress control permission checks
(already in 24-rc6-mm1).

Somebody please tell me it's my git-idiocy..

> simply reverting the "Convert the netif code to use ifindex values" patch 
> would solve the problem as there are other patches in the rc6-mm1 tree that 
> rely on skb->iif being valid (new code, not converted code).

That would explain why I'm still seeing issues..

>  If you want to 
> stick with a _relatively_ vanilla rc6-mm1 tree I would leave everything in 
> and simply apply the following patch which solved the skb_clone()/iif 
> problem:
> 
> http://git.infradead.org/?p=users/pcmoore/lblnet-2.6_testing;a=commitdiff;h=02f1c89d6e36507476f78108a3dcc78538be460b

OK, I'll go look at that..


--==_Exmh_1200339422_3045P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHi7necC3lWbTT17ARApWSAJoCRBTA+TdiD6uxi9gFnXLzsJUDgwCfT13L
DOuKABOin+QMHz1nM8AOUt4=
=fWeY
-----END PGP SIGNATURE-----

--==_Exmh_1200339422_3045P--
