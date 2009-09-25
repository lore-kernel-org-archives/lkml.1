Return-Path: <linux-kernel-owner+w=401wt.eu-S1752975AbZIYPAC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbZIYPAC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 11:00:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbZIYPAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 11:00:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:56677 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbZIYPAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 11:00:00 -0400
Date: Fri, 25 Sep 2009 17:00:06 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
       bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 17/63] edac_mce: Add an interface driver to report mce
 errors via edac
Message-ID: <20090925170006.68c2fae1@infradead.org>
In-Reply-To: <20090925144037.GA16340@aftab>
References: <20090924192727.212ce46f@pedra.chehab.org>
	<20090925094855.GA29551@aftab>
	<20090925091130.14135879@pedra.chehab.org>
	<20090925135626.GA8145@aftab>
	<20090925160501.03a0f37d@infradead.org>
	<20090925144037.GA16340@aftab>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Sep 2009 16:40:38 +0200
Borislav Petkov <borislav.petkov@amd.com> wrote:

> On Fri, Sep 25, 2009 at 04:05:01PM +0200, Arjan van de Ven wrote:
> > On Fri, 25 Sep 2009 15:56:26 +0200
> > > > 1) edac_mce is not a module (see patch 18). So, just calling a
> > > > routine on edac_mce should be safe, even at NMI;
> > > 
> > > no, I mean the ->check_error member - it could call into a module
> > > if i7core_edac is compiled as such.
> > 
> > calling modular code from NMI is not a fatal event though.
> 
> No, not really. However, I remember Andi raising a stability concern
> one time whether it'd be such a good idea to allow modules to hook
> into MCE critical path when the system is already unstable and about
> to panic.

module vs not does not make a difference here.

either it's good code or it's not, does not matter where it lives.

> 
> Therefore, we might want to decode critical MCEs in core kernel code
> and non-critical later, at a more appropriate time (aka in modules).
>

modules are also just an artificial carve-off of the kernel, nothing
more. 

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
