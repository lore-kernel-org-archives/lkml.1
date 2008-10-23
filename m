Return-Path: <linux-kernel-owner+w=401wt.eu-S1753607AbYJWNa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbYJWNa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 09:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbYJWNaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 09:30:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:58235 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbYJWNaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 09:30:15 -0400
Date: Thu, 23 Oct 2008 06:30:28 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] procfs: use WARN() rather than printk+backtrace
Message-ID: <20081023063028.684fa22e@infradead.org>
In-Reply-To: <20081023083547.GA32124@x200.localdomain>
References: <20081021064612.4578920c@infradead.org>
	<20081023083547.GA32124@x200.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2008 12:35:47 +0400
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Tue, Oct 21, 2008 at 06:46:12AM -0700, Arjan van de Ven wrote:
> > -			printk(KERN_WARNING "proc_dir_entry
> > '%s/%s' already registered\n",
> > +			WARN(1, KERN_WARNING "proc_dir_entry
> > '%s/%s' already registered\n",
> 
> Applied to proc.git
> 
> As a side note, seeing WARN twice on this line is depressing, and
> people use WARN(, KERN_ERR);
> 
> I mean, how hard is to get something conceptually simple as warning
> right? 

if we were consistent about which level we wanted these things at we
could fold that into the macro. Sadly that's not the case ;(
(and then there's the issue with multilines etc)
Also, WARN() tries to be as printk() compatible as possible, and that
includes the log level....

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
