Return-Path: <linux-kernel-owner+w=401wt.eu-S1752251AbXCYTyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbXCYTyH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 15:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbXCYTyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 15:54:06 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57978 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752267AbXCYTyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 15:54:05 -0400
Date: Sun, 25 Mar 2007 12:54:03 -0700
From: Paul Jackson <pj@sgi.com>
To: balbir@in.ibm.com
Cc: vatsa@in.ibm.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix race between attach_task and cpuset_exit
Message-Id: <20070325125403.3749b45c.pj@sgi.com>
In-Reply-To: <4606B6CF.6040306@in.ibm.com>
References: <20070325164746.GI11794@in.ibm.com>
	<4606B6CF.6040306@in.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> How about using a local variable like ref_count and using
> 
> ref_count = atomic_dec_and_test(&cs->count); This will avoid the two
> atomic operations, atomic_dec() and atomic_read() below.

This would also seem to address the race I just noticed in my previous
reply.

Though I would suggest that we use the same code pattern in both
cpuset_exit and attach_task -- either both use cpuset_to_be_released,
or both use ref_count.

I tend to prefer the cpuset_to_be_released form - seems a bit more
explicitly clear to me.  But vatsa's doing the patch - he gets the
last vote.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
