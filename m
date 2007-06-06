Return-Path: <linux-kernel-owner+w=401wt.eu-S933452AbXFFP2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452AbXFFP2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 11:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759777AbXFFP14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 11:27:56 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:44371 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099AbXFFP14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 11:27:56 -0400
Subject: Re: checkpointing and restoring processes
From: Dave Hansen <hansendc@us.ibm.com>
To: Mark Pflueger <pflueger@informatik.tu-muenchen.de>
Cc: linux-kernel@vger.kernel.org, Containers <containers@lists.osdl.org>
In-Reply-To: <Pine.GSO.4.64.0706061318010.16173@rayhalle1>
References: <Pine.GSO.4.64.0706061318010.16173@rayhalle1>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 08:27:31 -0700
Message-Id: <1181143652.22388.74.camel@spirit.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-06 at 13:37 +0200, Mark Pflueger wrote:
> hi everyone!
> 
> i'm not subscribed to the list, so if you care to flame because of my noob 
> question, just do it to the list, otherwise please cc me.
> 
> i'm trying to write a checkpoint/restore module for processes and so have 
> a basic version going already - problem is, when i restore the process, 
> one of three things happens at random. first is, the process restored 
> segfaults. second is, i get a kernel null pointer dereference and third 
> is, i get a virtual address lookup error and a kernel crash. the trace 
> back and the address always change.

Your patch definitely takes a simple, straightforward approach, which is
good.  But, there are a couple of things that need to get added.

For instance, when you make a copy of tsk->mm, what happens if that
original task exits?  It will drop its reference count and free that
task, along with the mm.  The new task will fault on its access to
newtsk->mm because the mm has gone away.

Also, just setting tsk->pid is not enough to get the pid to show up in
the system.  It needs to make sure no other task has that pid as well as
making entries in data structures like the pid allocation map.  

In any case, it's nice to have other people interested in the same
things!  As Cedric suggested, please pop over to
containers@lists.linux-foundation.org.  There are at least two other
efforts, besides ours working toward the same goal, so you'll have lots
of comrades there. ;)

-- Dave

