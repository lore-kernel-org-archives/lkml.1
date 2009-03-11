Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbZCKRvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbZCKRvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 13:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbZCKRux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 13:50:53 -0400
Received: from main.gmane.org ([80.91.229.2]:51229 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbZCKRuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 13:50:52 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Dmitriy V'jukov" <dvyukov@gmail.com>
Subject: Re: RCU: Number of grace-periods
Date: Wed, 11 Mar 2009 17:50:35 +0000 (UTC)
Message-ID: <loom.20090311T173526-125@post.gmane.org>
References: <loom.20090311T104939-544@post.gmane.org> <20090311155024.GB7086@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 209.3.12.206 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.7) Gecko/2009021910 Firefox/3.0.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck <at> linux.vnet.ibm.com> writes:
> 
> Interesting thought -- but please keep in mind that acquire/release fences
> still allow subsequent stores to be reordered to precede earlier loads.
> This means that the first loads in the RCU critical section could be
> reordered to precede the final store of the rcu_read_lock() primitive.


Hmmm... Yes, I've missed this moment. I think you are right. The critical
synchronizing action of the __rcu_read_lock() is the store to the
__get_cpu_var(rcu_flipctr) (not a load!). So some code from the critical section
can hoist above the store to the __get_cpu_var(rcu_flipctr).
However the good question is how many grace-periods is required if code can
hoist above read_lock(), but can't sink below read_unlock()?
Good work for Relacy :) Nope, I've not yet tried to apply it...


--
Best regards,
Dmitriy V'jukov

