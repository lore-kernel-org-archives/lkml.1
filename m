Return-Path: <linux-kernel-owner+w=401wt.eu-S1760285AbZADTgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760285AbZADTgY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 14:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756811AbZADTgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 14:36:03 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42886 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956AbZADTgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 14:36:00 -0500
Date: Sun, 4 Jan 2009 20:49:46 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, mingo@elte.hu, fweisbec@gmail.com,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/4] fastboot: Asynchronous function calls to speed up kernel boot
Message-ID: <20090104194946.GB496@one.firstfloor.org>
References: <20090104092430.7ffd2c41@infradead.org> <20090104092857.5fbf6b2d@infradead.org> <87k59aops9.fsf@basil.nowhere.org> <20090104110932.6563cc6d@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090104110932.6563cc6d@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 11:09:32AM -0800, Arjan van de Ven wrote:
> On Sun, 04 Jan 2009 20:05:26 +0100
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Surely the thread should die again boot up? On module load
> > synchronisity is usually not a problem.
> 
> sadly that's not correct in practice based on the fast boot work we've
> done.

Hmm, but I'm not sure your current code is module safe, in particular 
against unloading again. You would likely need a barrier at the end
of module load at least.

> 
> > 
> > Personally I think it would be better to make this more generic.
> > Various subsystems have thread pool implementations now, 
> 
> sort of kinda. If a good one appears I'd be happy to build on top of
> that, assuming it's generic enough.

I think you can just create a separate barrier primitive which
will work independently of any special thread managers.

> 
> > and this
> > is just another variant that except for the sequence stuff
> > isn't all that much different. So it would be better to have 
> > a generic worker thread manager that just supports these
> > barriers too.
> 
> ... or maybe think about seeing this system as exactly that thread
> manager?

I'm not sure it's generic enough.

-Andi

-- 
ak@linux.intel.com
