Return-Path: <linux-kernel-owner+w=401wt.eu-S1757772AbZDNQQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772AbZDNQQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756779AbZDNQQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:16:10 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:45647 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137AbZDNQQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:16:09 -0400
Date: Tue, 14 Apr 2009 11:16:01 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Ingo Molnar <mingo@elte.hu>, containers@lists.osdl.org,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Creating tasks on restart: userspace vs kernel
Message-ID: <20090414161601.GB8085@us.ibm.com>
References: <49E40662.2040508@cs.columbia.edu> <20090414095904.GD3558@elte.hu> <49E4A380.4070503@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E4A380.4070503@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@cs.columbia.edu):
> For #1, we need to create a new container to begin with. This already
> requires CAP_SYS_ADMIN. Yes, for now we can use some setuid() to create
> a new pid_ns and then do the restart.

This is why I like tagging a pidns with a userid, and requiring that
current->euid==pidns->uid in order to be allowed to set pid in that
pidns.

We require cap_sys_admin wil doing clone(CLONE_NEWPID).  So if we do
that while uid=500, then drop cap_sys_admin, then we can proceed to
create new tasks with specified pids in that pidns.

-serge
