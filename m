Return-Path: <linux-kernel-owner+w=401wt.eu-S1762401AbXJZRJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762401AbXJZRJ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbXJZRJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:09:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35121 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbXJZRJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:09:46 -0400
Date: Fri, 26 Oct 2007 10:05:53 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Russell King <rmk@arm.linux.org.uk>, linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression: commit "ide: constify struct ide_port_info" causes
 breakage
Message-ID: <20071026100553.754e20ab@laptopd505.fenrus.org>
In-Reply-To: <alpine.LFD.0.999.0710260929290.30120@woody.linux-foundation.org>
References: <20071026155648.GB4321@flint.arm.linux.org.uk>
	<47221164.10200@ru.mvista.com>
	<alpine.LFD.0.999.0710260929290.30120@woody.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007 09:30:20 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Fri, 26 Oct 2007, Sergei Shtylyov wrote:
> > 
> >    We can just convert cariables declared as 'struct hpt_info' to
> > const too -- they are read-only templates.
> 
> Generally "__devinitdata" is better than "const", since it means that
> the data may be thrown away.
> 
> So if you drop one over the other, it's generally the "const" that
> should be dropped ;/
> 

we could do a
__constdevinitdata
that translate to "const" for the "not throw away" cases, and to the
throw-away secontion for the other cases...
