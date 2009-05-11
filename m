Return-Path: <linux-kernel-owner+w=401wt.eu-S1753523AbZEKKyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbZEKKyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 06:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbZEKKx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 06:53:59 -0400
Received: from adelie.canonical.com ([91.189.90.139]:33612 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbZEKKx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 06:53:58 -0400
Date: Mon, 11 May 2009 11:53:54 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [FOR REVIEW, PATCH 2/2] introduce "struct wait_opts" to
	simplify do_wait() pathes
Message-ID: <20090511105354.GB30651@shadowen.org>
References: <20090506053324.GA31988@redhat.com> <20090506072756.GA17457@elte.hu> <20090507064120.GB15220@redhat.com> <20090507075417.GA9836@elte.hu> <20090509161506.GA8150@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090509161506.GA8150@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 09, 2009 at 06:15:06PM +0200, Oleg Nesterov wrote:
> (add Andy)
> 
> On 05/07, Ingo Molnar wrote:
> >
> > * Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > > On 05/06, Ingo Molnar wrote:
> > > >
> > > > One small nit with the definition above: when using vertical spacing
> > > > (which really looks nice) we tend to put the asterix to the type
> > > > itself, not to the variable. I.e.:
> > > >
> > > > 	enum pid_type		wtype;
> > > > 	struct pid *		wpid;
> > > > 	int			wflags;

My expectation would normally be that this would be written more as:

 	enum pid_type		wtype;
 	struct pid		*wpid;
 	int			wflags;

(more explanation below)

> > > >
> > > > ( This is done to separate the field name from the type - the
> > > >   pointer nature of the field is part of the type, not part of the
> > > >   name. )
> > >
> > > Indeed, I like this more too. But checkpatch.pl disagrees!
> >
> > That's probably a checkpatch bug mistaking * for multiplication -
> > ignore checkpatch in that case and please report it to Andy
> > Withcroft as well as well.

This is a C'ism.  The pointerness is not part of the type in C, where as
it is in C++.  In C a char * is a pointer to the type char (classically
written as "char *var").  In C++ char * is of type pointer to char
(classically written as "char* var").

> No, this is not a bug. From scripts/checkpatch.pl
> 
> 	1667                          # Should not end with a space.
> 	1668                          $to =~ s/\s+$//;
> 
> checkpatch explicitely dislikes "type * name". I think this is
> not really right, but I won't insist. Perhaps it is better to
> allow tabs before name at least, because this likely means the
> code really tries ro look good.

So yes the current behaviour is as designed.  We are aiming for a
consistent style not necessarily one any of us actually wholy agrees
with.  If the right people think this deserves relaxing we can revisit
that decision.

> Btw, can't resist,
> 
> 	while ($to =~ s/\*\s+\*/\*\*/) {
> 	}
> 
> I think this can be simplified to
> 
> 	$to =~ s/(?<=\*)\s+//g;

Heh quite possibly.  But the first is enough like line noise for me!
The latter is primarily scary.

> Oleg.

Thanks.

-apw
