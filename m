Return-Path: <linux-kernel-owner+w=401wt.eu-S932966AbXGWBVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966AbXGWBVB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 21:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756023AbXGWBUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 21:20:51 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:41543 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751401AbXGWBUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 21:20:50 -0400
Date: Mon, 23 Jul 2007 03:20:14 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Latchesar Ionkov <lucho@ionkov.net>,
       Eric Van Hensbergen <ericvh@gmail.com>
Cc: v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: net/9p/mux.c: use-after-free
Message-ID: <20070723012014.GV26212@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted the following use-after-free
in net/9p/mux.c:

<--  snip  -->

...
struct p9_conn *p9_conn_create(struct p9_transport *trans, int msize,
                                    unsigned char *extended)
{
...
        if (!m->tagpool) {
                kfree(m);
                return ERR_PTR(PTR_ERR(m->tagpool));
        }
...

<--  snip  -->


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

