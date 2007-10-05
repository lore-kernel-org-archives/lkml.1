Return-Path: <linux-kernel-owner+w=401wt.eu-S1759700AbXJEFx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759700AbXJEFx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 01:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbXJEFxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 01:53:20 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:58695 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbXJEFxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 01:53:20 -0400
Date: Thu, 4 Oct 2007 22:53:17 -0700
From: sukadev@us.ibm.com
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 0/3] Make tasks always have non-zero pids
Message-ID: <20071005055317.GB28111@us.ibm.com>
References: <4703A44F.9020402@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4703A44F.9020402@openvz.org>
User-Agent: Mutt/1.4.2.2i
X-Operating-System: Linux 2.0.32 on an i486
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelianov [xemul@openvz.org] wrote:
| Some time ago Sukadev noticed that the vmlinux size has

Cedric pointed it out to me first :-)

| grown 5Kb due to merged pid namespaces. One of the big
| problems with it was fat inline functions. The other thing
| was noticed by Matt - the checks for task's pid to be not
| NULL take place and make the kernel grow due to inlining,
| but these checks are not always needed.
| 
| In this series I introduce a static pid (dummy), according
| to Matt's proposal, which is assigned to tasks during the 
| detach_pid and transfer_pid instead of NULL. This pid lives 
| in the init pid namespace and has the id = 0, so all the 
| task_xid_xnr() calls will still return 0 on a dead task.
| 
| Places that get the struct pid from task either get it from
| the current (in this case they will never get this dummy),
| or use it to compare with some other value (so they will 
| work the same for both NULL and dummy pids).
| 
| This saves up to 340 bytes for i386 kernel with minimal 
| config  and probably more with more users of pids.
| 
| Tested on i386 and x86_64 boxes. Tasks still live and die,
| namespaces and proc still work.
| 
| Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

Acked-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
