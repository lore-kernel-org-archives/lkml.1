Return-Path: <linux-kernel-owner+w=401wt.eu-S1757961AbYKVCQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbYKVCQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 21:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbYKVCQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 21:16:35 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54971 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753653AbYKVCQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 21:16:35 -0500
Message-ID: <49276B79.9060002@cn.fujitsu.com>
Date: Sat, 22 Nov 2008 10:16:25 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       pbadari@us.ibm.com, jblunck@suse.de, taka@valinux.co.jp,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       npiggin@suse.de
Subject: Re: [PATCH 0/2] memcg: fix oom handling
References: <20081114191246.4f69ff31.kamezawa.hiroyu@jp.fujitsu.com>	<20081114191949.926bf99d.kamezawa.hiroyu@jp.fujitsu.com>	<49261F87.50209@cn.fujitsu.com> <20081121185829.e04c8116.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081121185829.e04c8116.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> Li Zefan reported
> 
> (a) This goes dead lock:
> ==
>    #echo 0 >  (...)/01/memory.limit_in_bytes   #set memcg's limit to 0,
>    #echo $$ > (...)/01/memory.tasks            #move task
>    # do something...
> ==
> 
> (b) seems to be dead lock
> ==
>    #echo 40k >  (...)/01/memory.limit_in_bytes   #set memcg's limit to 0,
>    #echo $$ > (...)/01/memory.tasks            #move task
>    # do something...
> ==
> 
> 
> I think (a) is BUG. (b) is just slow down.
> (you can see pgpgin/pgpgout count is increasing in (B).)
> 
> This patch set is for handling (a). Li-san, could you check ?

Yes, it works for me now. :)

> This works well in my environment.(means OOM-Killer is called in proper way.)
> 

