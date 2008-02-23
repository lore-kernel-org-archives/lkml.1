Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbYBWNLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbYBWNLR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 08:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbYBWNLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 08:11:06 -0500
Received: from w12a.httpserveur.net ([67.15.80.77]:37090 "HELO
	websiteout12.httpserveur.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750907AbYBWNLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 08:11:05 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Feb 2008 08:11:05 EST
X-Abuse: Please report all abuse immediately to abuse@httpserveur.net
Message-ID: <47C019D2.4060308@club-internet.fr>
Date: Sat, 23 Feb 2008 14:04:18 +0100
From: clowncoder <vincent-perrier@club-internet.fr>
User-Agent: Thunderbird 2.0.0.0 (X11/20070429)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Nework Emulation with UML, bug 8895
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
You can have a configured and running network inside a single linux machine,
only one script command is enough. After the start of all the machine, a
graphical representation of your topology helps your interactions with
the network. This virtual network can be downloaded at http://clownix.net,
I must warn you, it is a 350mega bz2 file-system that needs 4 giga on 
the host.
Very usefull for networking development in kernel as proved by bug 8895
that has been found with the above tool:

The uncorrected bug 8895:

file:  /usr/src/linux-2.6.24.2/net/ipv6/ip6_fib.c  line  796:   
"dst_free(&rt->u.dst);"

------- /Comment From qmiao <mailto:qmiao@centecnetworks.com> 2007-08-29 
23:33:07 /---

        fib6_add
                ...

                if (fn->leaf == NULL) {
                        fn->leaf = rt;    <--**-- rt is assigned to fn->leaf
                        atomic_inc(&rt->rt6i_ref);
                }
                ...
                err = fib6_add_rt2node(fn, rt, info); <-**- return -EEXIST
                ...
(Here err was not null)
                ...
                if (err) {
                        ...
                        dst_free(&rt->u.dst); <--**-- Actually rt is still in
tree (fn->leaf = rt /* see above */)
                        ...
                        }


