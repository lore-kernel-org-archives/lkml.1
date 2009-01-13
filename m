Return-Path: <linux-kernel-owner+w=401wt.eu-S1757834AbZAMCIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834AbZAMCIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 21:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbZAMCI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 21:08:29 -0500
Received: from smtp-out.google.com ([216.239.33.17]:48953 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772AbZAMCI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 21:08:28 -0500
X-Greylist: delayed 861 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jan 2009 21:08:28 EST
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=Ay95HXBRRiiOTTznAv9k5meRqWHc8dlJDZysU3qONCxDG0+yRO3DaHOix9qMls10k
	VoHhniGfZr3+UR2t3jEhQ==
Date: Mon, 12 Jan 2009 17:53:47 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Evgeniy Polyakov <zbr@ioremap.net>
cc: Bill Davidsen <davidsen@tmr.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
In-Reply-To: <20090112231728.GA23803@ioremap.net>
Message-ID: <alpine.DEB.2.00.0901121746220.20329@chino.kir.corp.google.com>
References: <20090112153304.GA19995@ioremap.net> <20090112154922.6003750b@lxorguk.ukuu.org.uk> <20090112155030.GA21063@ioremap.net> <20090112155239.5f677a17@lxorguk.ukuu.org.uk> <20090112155615.GA21350@ioremap.net> <20090112161931.6203f96e@lxorguk.ukuu.org.uk>
 <20090112162938.GA22647@ioremap.net> <496BCB7A.2010804@tmr.com> <20090112231728.GA23803@ioremap.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.24.198.85
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009, Evgeniy Polyakov wrote:

> Like anything that spawns a thread or process per request/client, or
> preallocates set of them which connect to the huge object like database.
> Most of the time database/server is killed first instead of comparably
> small clients.

No, the reverse is true: when a task is chosen for oom kill based on the 
badness heuristic, the oom killer first attempts to kill any child task 
that isn't attached to the same mm.  If the child shares an mm, both tasks 
must die before memory freeing can occur.

> In some cases it is possible to tune the environment, in
> others it is not that simple. This patch works for such situatons
> perfectly and does not require additional administrative burden, since
> it does not make thinge worse as a whole, but only better for the very
> commonly used cases, that's why I propose it for inclusion.
> 

It's an inappropriate addition since /proc/pid/oom_adj scores exist which 
can prefer or protect certain tasks over others when the oom killer 
chooses a target, including oom kill immunity.  These scores are inherited 
from parent tasks and can be tuned after the fork to your oom kill target 
preference.
