Return-Path: <linux-kernel-owner+w=401wt.eu-S1760051AbZAGRzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760051AbZAGRzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 12:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753661AbZAGRzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 12:55:05 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:36891 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbZAGRzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 12:55:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=KYmEx/gFMJ7cbWeuiCLVD8ArsVO1+xkt4aTdwEwrqLRMlRS+zucYuTswCH+6RTmcSj
         EwIBQPK8Ig2vulqt39iZ2GtDAd47qsLuWlt2gqcle+jXkvdISW+gWMKMLgthQr4oIfaE
         Wxo2jRZsUXAjkj64pPhiH4Oy7tVb2tOlHA+e8=
Date: Wed, 7 Jan 2009 19:54:56 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Roel Kluin <roel.kluin@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 0/4] ftrace: important updates
Message-ID: <20090107195456.3247bab5@daedalus.pq.iki.fi>
In-Reply-To: <20090107094905.GB16025@elte.hu>
References: <20090107041605.168020089@goodmis.org>
	<20090107094905.GB16025@elte.hu>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2009 10:49:05 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> >       ring-buffer: rename debugfs file tracing_on to writing_enabled
> 
> writing_enabled is at least as confusing as tracing_on - if not more so.
> 
> The user really does not care about all the deeper machinery that happens 
> in ftrace - the difference between a 'light' disabling of a tracer and a 
> 'heavy' disabling of a tracer (which means it unregisters itself 
> completely in essence).
> 
> To resolve this, we should probably hide this difference altogether (as i 
> have suggested to do many months ago, when this first came up), by 
> removing tracing_enabled.
> 
> A tracer can still be fully unregistered: by simply switching the current 
> tracer to the 'nop' tracer. tracing_on/off remains the lightweight version 
> that most users are interested in anyway.

This sounds even better. We should not need tracing_enabled anymore, since
the buffer size can be changed regardless. tracing_on is more useful to
mmiotrace than tracing_enabled, too, since mmiotrace does not implement
the proper pausing behaviour on the tracing_enabled trigger.

But if Steven wants to keep the "pause" semantics, should there be a
callback dispatched to the tracer from tracing_on, just like there is
from tracing_enabled currently? Of course the callback semantics would
be different and the usual reaction would be to do nothing. It would
only be meaningful to tracers that update data outside the ring buffer,
so that they can properly pause.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
