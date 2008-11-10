Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbYKJEoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbYKJEoI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 23:44:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbYKJEnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 23:43:55 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:33161 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbYKJEny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 23:43:54 -0500
Date: Mon, 10 Nov 2008 13:30:54 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "menage@google.com" <menage@google.com>, nishimura@mxp.nes.nec.co.jp
Subject: Re: [RFC][PATCH 5/6] memcg: mem+swap controller
Message-Id: <20081110133054.b090816c.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20081105172316.354c00fb.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081105171637.1b393333.kamezawa.hiroyu@jp.fujitsu.com>
	<20081105172316.354c00fb.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -1062,13 +1208,55 @@ int mem_cgroup_resize_limit(struct mem_c
>  			break;
>  		}
>  		progress = try_to_free_mem_cgroup_pages(memcg,
> -				GFP_HIGHUSER_MOVABLE);
> +				GFP_HIGHUSER_MOVABLE, false);
>  		if (!progress)
>  			retry_count--;
>  	}
>  	return ret;
>  }
>  
mem_cgroup_resize_limit() should verify that mem.limit <= memsw.limit
as mem_cgroup_resize_memsw_limit() does.


Thanks,
Daisuke Nishimura.
