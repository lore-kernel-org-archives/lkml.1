Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbZBIPZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbZBIPZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 10:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbZBIPZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 10:25:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:40748 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296AbZBIPZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 10:25:15 -0500
Date: Mon, 9 Feb 2009 07:25:31 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, mchehab@infradead.org
Subject: Re: [PATCH 1/3] module: create a request_module_nowait()
Message-ID: <20090209072531.5cf92d3a@infradead.org>
In-Reply-To: <200902091702.18887.rusty@rustcorp.com.au>
References: <20090208104201.6124ab6a@infradead.org>
	<200902091702.18887.rusty@rustcorp.com.au>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009 17:02:17 +1030
Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Monday 09 February 2009 05:12:01 Arjan van de Ven wrote:
> > This patch changes this to use a request_module_nowait() function
> > macro instead, which just fires the modprobe off but doesn't wait
> > for it, and thus avoids the original deadlock entirely.
> 
> Nice, applied.  Made one change; I've taken to using the new-fangled
> bool type for flag args, for slight extra clarity.
> 
> (Which uncovered another interesting issue, which lead to several more
>  patches).
> 

for this case that's a bit unfortunate though.

the call usermode helper code takes 3 values, -1, 0 and 1.
Right now the code only uses 0 and 1, but I've been looking at
using -1 as well in this exact codepath in case there is a problem with
the 0 option (the 0 option waits for the exec but not the result, the
-1 waits for nothing)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
