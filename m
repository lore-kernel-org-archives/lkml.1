Return-Path: <linux-kernel-owner+w=401wt.eu-S1758262AbYHDOgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262AbYHDOgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754859AbYHDOg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:36:27 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:12753 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbYHDOg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:36:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=ZBvOWaWlbF/pdOQsRbNIk5MlmUdFGUfotLsDAXC4vcSdQtQpDqQtZTz7+19aLTetcg
         O9nlCq4urDE91kT51WpOHY1O1iOamdzIyX1lbYgYvd3ASpkdWPCGIGYNTNx86/mR1Iy5
         04uQE727qdmZON9AH8xU0JrWHr+rfoO8ObjcQ=
Message-ID: <28c262360808040736u7f364fc0p28d7ceea7303a626@mail.gmail.com>
Date: Mon, 4 Aug 2008 23:36:25 +0900
From: "MinChan Kim" <minchan.kim@gmail.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Race condition between putback_lru_page and mem_cgroup_move_list
Cc: linux-mm <linux-mm@kvack.org>, "Rik van Riel" <riel@redhat.com>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Lee Schermerhorn" <lee.schermerhorn@hp.com>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this is a race condition if mem_cgroup_move_lists's comment isn't right.
I am not sure that it was already known problem.

mem_cgroup_move_lists assume the appropriate zone's lru lock is already held.
but putback_lru_page calls mem_cgroup_move_lists without holding lru_lock.

Repeatedly, spin_[un/lock]_irq use in mem_cgroup_move_list have a big overhead
while doing list iteration.

Do we have to use pagevec ?

-- 
Kinds regards,
MinChan Kim
