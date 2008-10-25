Return-Path: <linux-kernel-owner+w=401wt.eu-S1752191AbYJYOge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbYJYOge (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 10:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbYJYOgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 10:36:13 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:44573 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbYJYOgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 10:36:12 -0400
Date: Sat, 25 Oct 2008 16:35:28 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [pull request] getting rid of __cpuinit
Message-ID: <20081025143528.GA30900@uranus.ravnborg.org>
References: <20081024142056.6a2d082a@infradead.org> <20081025075925.GA22805@uranus.ravnborg.org> <20081025070043.50578543@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081025070043.50578543@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2008 at 07:00:43AM -0700, Arjan van de Ven wrote:
> On Sat, 25 Oct 2008 09:59:25 +0200
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > >    text	   data	    bss	    dec
> > > hex	filename 4618096	1358684	 848588
> > > 6825368	 682598	vmlinux.before 4619965
> > > 1356908	 848716	6825589  682675	vmlinux.after
> > 
> > The interesting number here is the size of the cpuinit/cpuexit
> > sections. cpuinit sections are discarded after init and cpuexit
> > sections are discarded if you do not use modules.
> > 
> > Can you share these numbers with us?
> 
> those sections don't actually exist because of the linker script 
> magic...
The code exist in both the before and after case, only in the after case
you cannot distingush them.
Your patch simply moves code/data from the cpuinit/exit sections
to .text/.data.

So if you look at the size of the cpuinit/exit sections in the
before case you get the real space saving that is lost in the
embedded case after your patch is applied.
The space savings that happen after early init.

As for the complexity of especially the cpuinit/exit stuff
the reason is that whoever started to use this mechnishm extended
the __cpuinit case to be:

a) Code that is only used during early init and can be discarded
b) Code that is only used for CPU hotplugging


The a) case is the traditional way __fooinit is used.
The b) case is usually handled by our configuration
but for CPU hotplugging it was misused.


Let us please get the numbers correct before we rip it out.

	Sam
