Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbXLDXEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbXLDXEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 18:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbXLDXEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 18:04:37 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:35956 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbXLDXEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 18:04:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rZbDxLo5tHBA8ojyXNtxM4s4iEcbxxxXlj6S/mBmpOi3F0DD6q+kT0K5Ms2cdRGnfebWWBZlLcou4LX9DLQYg2VPoFrPVJEXN6GkQ3APG2/8tieL71Qiv+YJmSN7HF658O+BauQfPd6KlW9083Lx/w4KyihINd9u2GFJT0JGNHo=
Subject: Re: [RFC PATCH] x86: Unify include/asm-x86/linkage_[32|64].h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071204224543.GH15974@stusta.de>
References: <1196801629.10408.26.camel@brick>
	 <20071204213247.GA11216@elte.hu> <1196806868.10408.33.camel@brick>
	 <20071204222717.GA25974@elte.hu>  <20071204224543.GH15974@stusta.de>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 14:57:55 -0800
Message-Id: <1196809075.10408.42.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-12-04 at 23:45 +0100, Adrian Bunk wrote:
> On Tue, Dec 04, 2007 at 11:27:17PM +0100, Ingo Molnar wrote:
> > 
> > * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> > 
> > > On Tue, 2007-12-04 at 22:32 +0100, Ingo Molnar wrote:
> > > > * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> > > > 
> > > > > I'm not sure if the definition of asmlinkage and prevent_tail_call can 
> > > > > be omitted as well and let the linux/linkage.h version get picked up 
> > > > > instead.
> > > > 
> > > > no, we cannot remove them - asmlinkage is needed for the syscall 
> > > > entry (and other entry code) to work, the and the prevent_tail_call 
> > > > works around a compiler bug. (which might or might not be fixed in 
> > > > latest gcc - but we generally dont remove workarounds unless we are 
> > > > really sure it's fine.)
> > > 
> > > OK, but if this patch is acceptable, then there is no more places in 
> > > the tree that define the FASTCALL macro, other than the empty default 
> > > in include/linux/linkage.h.  So I think a second step would be to 
> > > start to get rid of FASTCALL callers elsewhere in the tree...thoughts?
> > 
> > the removal of FASTCALL is fine: the default (and only) compiler model 
> > for x86 (32-bit) is regparm(3), so the regparm(3) macro is equivalent to 
> > the empty one in linux/linkage.h.
> >...
> 
> But please ensure that they stay in assembler code also used by UML.

I'm curious how UML is using FASTCALL/fastcall.  Any pointers?

Harvey

