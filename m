Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbZIHCM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbZIHCM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 22:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbZIHCM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 22:12:27 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:45786 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbZIHCM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 22:12:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m6lJF1Qr9dWe1Z8E12SgZQw/QCMTVBKWW97AlpQKc+QrnXPb6LmGtwl5Qs+ewJ2+hr
         o1cVt8rK4lN13QdVKzegJodpOvlZXdRS8xPsVy8M7EJpaStWVGHB9zID/xQqsMqNyImD
         uM4vgj+fgO0hewbTE3een3BeDIcIoki0ysjGQ=
Date: Tue, 8 Sep 2009 04:12:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] perf trace: Add filter support
Message-ID: <20090908021224.GD6312@nowhere>
References: <4AA4C04D.1050201@cn.fujitsu.com> <20090908000219.GB6312@nowhere> <4AA5AE29.6020107@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA5AE29.6020107@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 09:06:49AM +0800, Li Zefan wrote:
> >> An example:
> >>
> >>  #./perf record -f -e irq:irq_handler_entry:irq==18:record
> >>  or
> >>  #./perf record -f -e irq:irq_handler_entry:irq==18 -R
> >>  ^C
> > 
> > We may want to write complex filters. While looking at this patchset,
> > that seems possible this way, but the raw line may become unreadable:
> > 
> > perf record -f -e irq:irq_handler_entry:"irq==18 && (name == 'foo' || bar == 'blah')":record
> > 
> > May be we should add an option to let one also set the filters seperately then
> > we could do:
> > 
> > perf record -f -e -R irq:irq_handler_entry --filter "irq==18 && (name == 'foo' || bar == 'blah')"
> > 
> 
> I had the same idea. ;)
> 
> But using this option, is it possible to specify different filters
> for different events? like this:
> 
> perf record -f -e -R irq:irq_handler_entry --filter "irq==18"
> -e irq:softirq_entry --filter "vec==1"
> 


Exactly how I was imagining it :)

