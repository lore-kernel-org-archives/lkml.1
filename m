Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbZAHLA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbZAHLA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 06:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbZAHLAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 06:00:50 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34492 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbZAHLAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 06:00:49 -0500
Message-ID: <37143.10.75.179.62.1231412446.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20090108191445.cd860c37.nishimura@mxp.nes.nec.co.jp>
References: <20090108190818.b663ce20.nishimura@mxp.nes.nec.co.jp>
    <20090108191445.cd860c37.nishimura@mxp.nes.nec.co.jp>
Date: Thu, 8 Jan 2009 20:00:46 +0900 (JST)
Subject: Re: [RFC][PATCH 2/4] memcg: fix error path of 
     mem_cgroup_move_parent
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Daisuke Nishimura" <nishimura@mxp.nes.nec.co.jp>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
       lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain;charset=us-ascii
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daisuke Nishimura said:
> There is a bug in error path of mem_cgroup_move_parent.
>
> Extra refcnt got from try_charge should be dropped, and usages incremented
> by try_charge should be decremented in both error paths:
>
>     A: failure at get_page_unless_zero
>     B: failure at isolate_lru_page
>
> This bug makes this parent directory unremovable.
>
> In case of A, rmdir doesn't return, because res.usage doesn't go
> down to 0 at mem_cgroup_force_empty even after all the pc in
> lru are removed.
> In case of B, rmdir fails and returns -EBUSY, because it has
> extra ref counts even after res.usage goes down to 0.
>
>
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Thank you for catching.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


