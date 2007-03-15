Return-Path: <linux-kernel-owner+w=401wt.eu-S1422786AbXCOAgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422786AbXCOAgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 20:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422787AbXCOAgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 20:36:46 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43498 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1422786AbXCOAgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 20:36:45 -0400
Date: Wed, 14 Mar 2007 19:36:43 -0500
From: Robin Holt <holt@sgi.com>
To: Nathan Lynch <ntl@pobox.com>
Cc: Cliff Wickman <cpw@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] hotplug cpu: migrate a task within its cpuset
Message-ID: <20070315003642.GB7338@lnx-holt.americas.sgi.com>
References: <20070309193925.B60891B8028@attica.americas.sgi.com> <20070309235859.GA20093@localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309235859.GA20093@localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 05:58:59PM -0600, Nathan Lynch wrote:
> Hello-
> 
> Cliff Wickman wrote:
> > This patch would insert a preference to migrate such a task to a cpu within
> > its cpuset (and set its cpus_allowed to its cpuset).
> > 
> > With this patch, migrate the task to:
> >  1) to any cpu on the same node as the disabled cpu, which is both online
> >     and among that task's cpus_allowed
> >  2) to any online cpu within the task's cpuset
> >  3) to any cpu which is both online and among that task's cpus_allowed
> 
> I think I disagree with this change.
> 
> The kernel shouldn't have to be any smarter than it already is about
> moving tasks off an offlined cpu.  The only way case 2) can be reached
> is if the user has changed a task's cpu affinity.  If the user is
> sophisticated enough to manipulate tasks' cpu affinity then they can
> arrange to migrate tasks as they see fit before offlining a cpu.

You are assuming some sort of interlock between the admin and the user.
While this may be true on your own personal desktop, I don't think you
can expect this to be true on a development machine shared by hundreds
of users and admin'd by a group of people.

Additionally, ia64 is gaining support for offlining a cpu which is giving
cache errors.

Thanks,
Robin
