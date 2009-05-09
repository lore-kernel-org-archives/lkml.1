Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbZEIQTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbZEIQTZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 12:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZEIQTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 12:19:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48041 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbZEIQTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 12:19:16 -0400
Date: Sat, 9 May 2009 18:15:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: Re: [FOR REVIEW, PATCH 2/2] introduce "struct wait_opts" to
	simplify do_wait() pathes
Message-ID: <20090509161506.GA8150@redhat.com>
References: <20090506053324.GA31988@redhat.com> <20090506072756.GA17457@elte.hu> <20090507064120.GB15220@redhat.com> <20090507075417.GA9836@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507075417.GA9836@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(add Andy)

On 05/07, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > On 05/06, Ingo Molnar wrote:
> > >
> > > One small nit with the definition above: when using vertical spacing
> > > (which really looks nice) we tend to put the asterix to the type
> > > itself, not to the variable. I.e.:
> > >
> > > 	enum pid_type		wtype;
> > > 	struct pid *		wpid;
> > > 	int			wflags;
> > >
> > > ( This is done to separate the field name from the type - the
> > >   pointer nature of the field is part of the type, not part of the
> > >   name. )
> >
> > Indeed, I like this more too. But checkpatch.pl disagrees!
>
> That's probably a checkpatch bug mistaking * for multiplication -
> ignore checkpatch in that case and please report it to Andy
> Withcroft as well as well.

No, this is not a bug. From scripts/checkpatch.pl

	1667                          # Should not end with a space.
	1668                          $to =~ s/\s+$//;

checkpatch explicitely dislikes "type * name". I think this is
not really right, but I won't insist. Perhaps it is better to
allow tabs before name at least, because this likely means the
code really tries ro look good.


Btw, can't resist,

	while ($to =~ s/\*\s+\*/\*\*/) {
	}

I think this can be simplified to

	$to =~ s/(?<=\*)\s+//g;

Oleg.

