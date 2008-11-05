Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbYKEDJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbYKEDJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 22:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbYKEDJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 22:09:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753726AbYKEDJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 22:09:49 -0500
Date: Tue, 4 Nov 2008 19:09:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, npiggin@suse.de,
       dfults@sgi.com, linux-kernel@vger.kernel.org, rientjes@google.com,
       containers@lists.osdl.org, menage@google.com
Subject: Re: [patch 0/7] cpuset writeback throttling
Message-Id: <20081104190908.295a3d53.akpm@linux-foundation.org>
In-Reply-To: <20081105103123.66dcb902.kamezawa.hiroyu@jp.fujitsu.com>
References: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
	<20081104124753.fb1dde5a.akpm@linux-foundation.org>
	<1225831988.7803.1939.camel@twins>
	<20081104131637.68fbe055.akpm@linux-foundation.org>
	<1225833710.7803.1993.camel@twins>
	<20081104135004.f1717fcf.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0811041601100.5077@quilx.com>
	<20081104143534.b5c16147.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0811041648350.6254@quilx.com>
	<20081104153610.bbfd5ed8.akpm@linux-foundation.org>
	<20081105103123.66dcb902.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2008 10:31:23 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> > 
> > Yes?  Someone help me out here.  I don't yet have my head around the
> > overlaps and incompatibilities here.  Perhaps the containers guys will
> > wake up and put their thinking caps on?
> > 
> > 
> > 
> > What happens if cpuset A uses nodes 0,1,2,3,4,5,6,7,8,9 and cpuset B
> > uses nodes 0,1?  Can activity in cpuset A cause ooms in cpuset B?
> > 
> For help this, per-node-dirty-ratio-throttoling is necessary.
> 
> Shouldn't we just have a new parameter as /proc/sys/vm/dirty_ratio_per_node.

I guess that would work.  But it is a general solution and will be less
efficient for the particular setups which are triggering this problem.

> /proc/sys/vm/dirty_ratio works for throttling the whole system dirty pages.
> /proc/sys/vm/dirty_ratio_per_node works for throttling dirty pages in a node.
> 
> Implementation will not be difficult and works enough against OOM.

Yup.  Just track per-node dirtiness and walk the LRU when it is over
threshold.

