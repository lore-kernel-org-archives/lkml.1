Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbZIERGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbZIERGa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 13:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbZIERG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 13:06:29 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:47943 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbZIERG3 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 13:06:29 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: RCU Kconfig help text
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1252157230_2420P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 05 Sep 2009 09:27:10 -0400
Message-ID: <12924.1252157230@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1252157230_2420P
Content-Type: text/plain; charset=us-ascii

init/Kconfig says:

"choice
        prompt "RCU Implementation"
        default TREE_RCU

config TREE_RCU
        bool "Tree-based hierarchical RCU"
        help
          This option selects the RCU implementation that is
          designed for very large SMP system with hundreds or
          thousands of CPUs.  It also scales down nicely to
          smaller systems.

config TREE_PREEMPT_RCU
        bool "Preemptable tree-based hierarchical RCU"
        depends on PREEMPT
        help
          This option selects the RCU implementation that is
          designed for very large SMP systems with hundreds or
          thousands of CPUs, but for which real-time response
          is also required.

endchoice"

This leaves somebody who has a laptop wondering which choice is best for
a system with only one or two cores that has CONFIG_PREEMPT defined. One
choice says it scales down nicely, the other explicitly has a 'depends on
PREEMPT' attached to it...

(Yes, I realize in practice, the RCU sections on a laptop are probably usually
so short they don't matter in practice.  I finally concluded TREE_PREEMPT was
apparently a rename of CONFIG_PREEMPT_RCU and went with that since that was
working for me before...)


--==_Exmh_1252157230_2420P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKomcucC3lWbTT17ARAsNHAKDsJbCbSXHwXFTyjtae5RN81B9s2ACg2MSB
YjUnqcllZFVODsaSo7h+NFY=
=WpR2
-----END PGP SIGNATURE-----

--==_Exmh_1252157230_2420P--
