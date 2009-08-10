Return-Path: <linux-kernel-owner+w=401wt.eu-S1754164AbZHJApr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbZHJApr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 20:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbZHJApr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 20:45:47 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59873 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbZHJApq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 20:45:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 10 Aug 2009 09:43:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       andi.kleen@intel.com, Prarit Bhargava <prarit@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: Help Resource Counters Scale Better (v3)
Message-Id: <20090810094344.77a8ef55.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090810093229.10db7185.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090807221238.GJ9686@balbir.in.ibm.com>
	<39eafe409b85053081e9c6826005bb06.squirrel@webmail-b.css.fujitsu.com>
	<20090808060531.GL9686@balbir.in.ibm.com>
	<99f2a13990d68c34c76c33581949aefd.squirrel@webmail-b.css.fujitsu.com>
	<20090809121530.GA5833@balbir.in.ibm.com>
	<20090810093229.10db7185.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Aug 2009 09:32:29 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> 1. you use res_counter_read_positive() in force_empty. It seems force_empty can
>    go into infinite loop. plz check. (especially when some pages are freed or swapped-in
>    in other cpu while force_empry runs.)
> 
> 2. In near future, we'll see 256 or 1024 cpus on a system, anyway.
>    Assume 1024cpu system, 64k*1024=64M is a tolerance.
>    Can't we calculate max-tolerane as following ?
>   
>    tolerance = min(64k * num_online_cpus(), limit_in_bytes/100);
>    tolerance /= num_online_cpus();
>    per_cpu_tolerance = min(16k, tolelance);
> 
>    I think automatic runtine adjusting of tolerance will be finally necessary,
>    but above will not be very bad because we can guarantee 1% tolerance.
> 

Sorry, one more.

3. As I requested when you pushed softlimit changes to mmotom, plz consider
   to implement a way to check-and-notify gadget to res_counter.
   See: http://marc.info/?l=linux-mm&m=124753058921677&w=2

Thanks,
-Kame

