Return-Path: <linux-kernel-owner+w=401wt.eu-S934513AbXHHOLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934513AbXHHOLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbXHHOLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:11:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42653 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142AbXHHOLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:11:35 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Glauber de Oliveira Costa" <glommer@gmail.com>
Subject: Re: [PATCH 18/25] [PATCH] turn priviled operations into macros in entry.S
Date: Wed, 8 Aug 2007 16:11:24 +0200
User-Agent: KMail/1.9.6
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>, lguest@ozlabs.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       chrisw@sous-sol.org, anthony@codemonkey.ws, akpm@linux-foundation.org,
       mingo@elte.hu
References: <11865467522495-git-send-email-gcosta@redhat.com> <200708081138.23018.ak@suse.de> <5d6222a80708080658j780667c4o52e924f8690f2a85@mail.gmail.com>
In-Reply-To: <5d6222a80708080658j780667c4o52e924f8690f2a85@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708081611.25152.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 August 2007 15:58:06 Glauber de Oliveira Costa wrote:

> On 8/8/07, Andi Kleen <ak@suse.de> wrote:
> >
> > > +#define SYSRETQ                                              \
> > > +                     movq    %gs:pda_oldrsp,%rsp;    \
> > > +                     swapgs;                         \
> > > +                     sysretq;
> >
> > When the macro does more than sysret it should have a different
> > name
> That's fair. Again, suggestions are welcome. Maybe SYSCALL_RETURN ?

Sounds reasonable.

> > >  retint_restore_args:
> > > -     cli
> > > +     DISABLE_INTERRUPTS(CLBR_ANY)
> >
> > Similar.
> I don't think so. They are live here, but restore_args follows, so we
> can safely clobber anything here. Right?

The non argument registers cannot be clobbered.



-Andi
