Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbZBEN1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbZBEN1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 08:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbZBEN1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 08:27:09 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39507 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347AbZBEN1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 08:27:08 -0500
Message-ID: <19fabd2ab6062c563832d0caa85deaa7.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20090205131741.GC6915@linux.vnet.ibm.com>
References: <20090205185959.7971dee4.kamezawa.hiroyu@jp.fujitsu.com>
    <20090205131741.GC6915@linux.vnet.ibm.com>
Date: Thu, 5 Feb 2009 22:27:02 +0900 (JST)
Subject: Re: [RFC][PATCH] Reduce size of swap_cgroup by CSS ID
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: paulmck@linux.vnet.ibm.com
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Thu, Feb 05, 2009 at 06:59:59PM +0900, KAMEZAWA Hiroyuki wrote:

>> +static struct mem_cgroup *mem_cgroup_lookup_get(unsigned short id)
>> +{
>> +	struct cgroup_subsys_state *css;
>> +
>> +	/* ID 0 is unused ID */
>> +	if (!id)
>> +		return NULL;
>> +	css = css_lookup(&mem_cgroup_subsys, id);
>> +	if (css && css_tryget(css))
>> +		return container_of(css, struct mem_cgroup, css);
>
> So css_tryget(), if successful, prevents the structure referenced by
> css from being freed, correct?  (If not, the range of the RCU read-side
> critical sections surrounding calls to mem_cgroup_lookup_get() must be
> extended.)
>
One reference to css by css_tryget() prevents rmdir(). So, css will
not be freed until css_put() is called.

Thanks,
-Kame

