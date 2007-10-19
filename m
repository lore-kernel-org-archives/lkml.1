Return-Path: <linux-kernel-owner+w=401wt.eu-S1764255AbXJSKSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764255AbXJSKSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 06:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbXJSKSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 06:18:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:45513 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753246AbXJSKSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 06:18:23 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19VrRNVOxhVlUPWq5RLPLAR8TSlhNuGqak5+K4lCx
	EkGR7fef0X6V+9
Subject: Re: [bisected][mismerge?] Re: [microcode] 2.6.23.git pulled this
	morning oopses loading P4 microcode
From: Mike Galbraith <efault@gmx.de>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1192762138.6838.13.camel@Homer.simpson.net>
References: <1192681533.7147.5.camel@Homer.simpson.net>
	 <1192730198.7182.18.camel@Homer.simpson.net>
	 <20071018223333.GD4153@implementation>
	 <1192762138.6838.13.camel@Homer.simpson.net>
Content-Type: text/plain; charset=ISO-8859-1
Date: Fri, 19 Oct 2007 12:18:19 +0200
Message-Id: <1192789099.7389.31.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-19 at 04:49 +0200, Mike Galbraith wrote: 
> On Thu, 2007-10-18 at 23:33 +0100, Samuel Thibault wrote:
> > Hi,
> > 
> > Mike Galbraith, le Thu 18 Oct 2007 19:56:38 +0200, a écrit :
> > > The winner of a very long git bisect session:
> > > 
> > >     unicode diacritics support
> > 
> > Uh, I fail to see how that could have an impact, I've again checked the
> > boundaries, it looks fine, please people have a look.
> 
> I too was reluctant to believe the bisect result.  But...

Weeeell now, that skepticism is indeed well founded.  It's dontdiff.  A
diff of trees where defkeymap.c_shipped has been modified produces no
output.  Once a working tree has been afflicted by using diff+dontdiff
to update it, even overwriting the entire tree via git-archive doesn't
lead to a good build unless you also touch defkeymap.c_shipped
afterward.  In my case, the working tree remained buildable yet
thoroughly busted through a lengthy bisect and beyond.  That bisect
positively identified... the victim.

poo.

	-Mike

