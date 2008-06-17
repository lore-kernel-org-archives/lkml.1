Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbYFQD0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbYFQD0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 23:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbYFQD0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 23:26:14 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52765 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbYFQD0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 23:26:14 -0400
Date: Tue, 17 Jun 2008 12:31:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] memcg: Reduce usage at change limit
Message-Id: <20080617123144.ce5a74fa.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, this is a patch for reducing usage at the change of limit for memcg.
A cut out from hierarchy patch set.I added Andrew Morton to CC.

I think this version is enough neat and small. 
This patch implements only necessary things.

Change log (hierarchy set's) v4 -> (this version) v5.
 - just for changing limit.
 - avoid to add rich limit handlers to res_counter because..
   1. memcg is maybe an only user which shrink_usage can be implemented.
   2. Many objections ;)

This patch adds feedback control at set_limit as following

   -> user's request to set limit to 'val'
      1. try to set limit to 'val'
      2. at success goto 6.
      3. try to shrink usage...
      4. if we cannot make progress any more, return -EBUSY.
      5. goto 1.
      6. successs.

Tested on x86-64.

Thanks,
-Kame

