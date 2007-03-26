Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbXCZR6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbXCZR6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 13:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbXCZR6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 13:58:25 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50057 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753427AbXCZR6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 13:58:24 -0400
Date: Mon, 26 Mar 2007 10:58:13 -0700
From: Paul Jackson <pj@sgi.com>
To: vatsa@in.ibm.com
Cc: balbir@in.ibm.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix race between attach_task and cpuset_exit
Message-Id: <20070326105813.5678ea5d.pj@sgi.com>
In-Reply-To: <20070326115046.GK11794@in.ibm.com>
References: <20070325164746.GI11794@in.ibm.com>
	<4606B6CF.6040306@in.ibm.com>
	<20070326115046.GK11794@in.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vatsa wrote:
> Well, someone may have attached to this cpuset while we were waiting on the 
> mutex_lock(). So we need to do a atomic_read again to ensure it is still
> unused.

I don't see how this could happen.  If we hold the task lock that now
(thanks to your good work) guards this pointer, and if we decrement to
zero the reference count on the cpuset to which it points and then
-overwrite- this last remaining visible pointer to that cpuset with a
pointer to a different cpuset, then aren't we guaranteed to be holding
the last remaining reference to the old cpuset in our local variable,
making it impossible for anyone else to attach to it in any way?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
