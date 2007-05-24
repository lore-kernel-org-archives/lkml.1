Return-Path: <linux-kernel-owner+w=401wt.eu-S1763061AbXEXF3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763061AbXEXF3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 01:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763414AbXEXF3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 01:29:10 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:40343 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763277AbXEXF3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 01:29:08 -0400
Date: Thu, 24 May 2007 10:58:49 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bernhard Walle <bwalle@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix crash with irqpoll due to the IRQF_IRQPOLL flag
Message-ID: <20070524052849.GA26967@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070426093620.GB2626@in.ibm.com> <20070426082405.67a0fdd2.akpm@linux-foundation.org> <20070430084833.GA16173@in.ibm.com> <20070502221932.GA488@suse.de> <20070508171841.GA29733@in.ibm.com> <20070514140513.GD29616@suse.de> <20070522083756.GB18498@suse.de> <alpine.LFD.0.98.0705230836370.3890@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705230836370.3890@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 09:01:04AM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 22 May 2007, Bernhard Walle wrote:
> >
> > o System crashes if booted with irqpoll command line option.
> > 
> > o Problem happens because Inside note_interrupt() we are accessing
> >   desc->action->flag without taking the desc->lock. While accessing it
> >   somebody goes ahead and unregisters the irq handler hence desc->action
> >   is NULL. By the time note_interrupt() checks it, it crashes.
> 
> I absolutely _detest_ patches that make already complex and unreadable 
> code even more so. Especially conditionals. Please don't do that.
> 
> If you need a variable for a conditional, make it be an implicit one from 
> an inline function, and aim for making it readable.
> 
> So how about instead writing it out as a nice self-explanatory inline 
> function? I can almost guarantee that this generates no worse code, and it 
> also makes it easy to explain things like "we don't bother with the lock, 
> because we don't care enough".
> 
> Untested, but I think the point of the patch is obvious. Anybody want to 
> test it, send it back to me, and fix the bug while making the code more 
> readable?
> 

Hi Linus,

I tested it. It works fine. And yes, this patch is more readable.

Thanks
Vivek
