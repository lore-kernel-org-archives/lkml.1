Return-Path: <linux-kernel-owner+w=401wt.eu-S1753752AbZAUFel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbZAUFel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 00:34:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbZAUFe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 00:34:28 -0500
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.206.88]:48381 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbZAUFe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 00:34:26 -0500
X-Greylist: delayed 1860 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Jan 2009 00:34:26 EST
Date: Wed, 21 Jan 2009 00:03:11 -0500
From: Jan Harkes <jaharkes@cs.cmu.edu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coda: alloc_upcall: s/task_pgrp_nr/task_pgrp_vnr/
Message-ID: <20090121050311.GD15771@cs.cmu.edu>
Mail-Followup-To: Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Pavel Emelyanov <xemul@openvz.org>,
	Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org
References: <20090118073453.GA714@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090118073453.GA714@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 08:34:53AM +0100, Oleg Nesterov wrote:
> Needs an ack from maintaner, I do not know where coda_in_hdr->pgid is used.

It is used to uniquely identify a process and any of it children during
conflict resolution.

When a conflict is detected, all accesses to the inconsistent object are
blocked. A special resolver process is forked off by the cache manager
and this is run in a new process group and only accesses from processes
in this group are allowed. The resolver process (or any of it's children)
compare the conflicting replicas, and ideally resolve the inconsistency
after which normal accesses are unblocked.

So yes this should not a per namespace thing, but also not a process
specific pid, the resolver forks off different helper processes
depending on the type of files that are involved in the conflict, i.e.
mbox files require different merge strategy compared to opendocument
files.

I'm not sure what you are trying to do.

Jan
