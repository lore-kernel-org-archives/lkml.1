Return-Path: <linux-kernel-owner+w=401wt.eu-S964841AbXBLJyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964841AbXBLJyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 04:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964842AbXBLJyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 04:54:44 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:42412 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964841AbXBLJyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 04:54:44 -0500
Date: Mon, 12 Feb 2007 01:52:00 -0800
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: akpm@osdl.org, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, vatsa@in.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, devel@openvz.org
Subject: Re: [PATCH 0/7] containers (V7): Generic Process Containers
Message-Id: <20070212015200.cb795924.pj@sgi.com>
In-Reply-To: <6599ad830702120132r181d338cy28b23736fa393de5@mail.gmail.com>
References: <20070212081521.808338000@menage.corp.google.com>
	<20070212011843.c6e8f4ae.pj@sgi.com>
	<6599ad830702120132r181d338cy28b23736fa393de5@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M, responding to Paul J:
> I think it could be made smarter than that, e.g. have a workqueue task
> that's only woken when a refcount does actually reach zero. (I think
> that waking a workqueue task is something that can be done without too
> much worry about locks)
> 
> >
> > Can you explain to me how this intruded on the reference counting?
> >
> 
> Essentially, it means that anything that releases a reference count on
> a container needs to be able to trigger a call to the release agent.
> The reference count is often released at a point when important locks
> are held, so you end up having to pass buffers into any function that
> might drop a ref count, in order to store a path to a release agent to
> be invoked.

Ok - now that you put it like that - it's much more persuasive.

Consider me sold on this aspect of your proposal, until and unless I
protest otherwise, which is not likely.

Thanks.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
