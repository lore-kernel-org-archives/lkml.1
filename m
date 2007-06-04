Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbXFDWU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbXFDWU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbXFDWUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:20:14 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:44019 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104AbXFDWUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:20:12 -0400
Date: Mon, 4 Jun 2007 18:20:10 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>, Nicholas Mc Guire <mcguire@lzu.edu.cn>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 9/9] Scheduler profiling - Use conditional calls
Message-ID: <20070604222010.GA1169@Krystal>
References: <20070530140025.917261793@polymtl.ca> <20070530140229.811672406@polymtl.ca> <p736469dsdb.fsf@bingen.suse.de> <20070531220742.GG904@Krystal> <20070531223322.GC7217@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070531223322.GC7217@one.firstfloor.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:15:46 up 7 days,  6:54,  3 users,  load average: 0.87, 0.42, 0.37
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> > I see your point, but there is a level of control on the branch I would
> > lack by doing so: the ability to put the call in either the if or else
> > branch. It is an optimization on i386.
> 
> What does it optimize exactly?
> 

Nicholas McGuire told me that the non common cases should be put in
else branches of if statements for i386. At the time, I did a quick test
that correlated what he said, but I seem to be unable to reproduce this
behavior now (maybe my code snippet is too simple?): I will then assume
that the likely/unlikely (builtin expects) tells everything that is
needed to gcc until further notice. Therefore, we can use the form :

if (cond_call(var)), as you proposed.

> > Also, I live in the expectation that, someday, the gcc guys will be nice
> > enough to add some kind of support for a nop-based jump that would
> > require code patching to put a jump instead. If it ever happens, my
> > macro could evolve into this for newer compiler versions, which I could
> > not do with the if() statement you are proposing.
> 
> If that ever happens we couldn't use it anyways because Linux still
> has to support old compilers for a long time. And when those are dropped the
> code could be updated.
> 

Agreed.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
