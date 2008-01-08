Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbYAHUQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbYAHUQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 15:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbYAHUQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 15:16:14 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:38126 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbYAHUQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 15:16:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=n8Ed9Dji28J/GKouqe6fr3Oq/1CCXsstwY5pf2l6NLnRU8I1rrVdeH6HF5d3B/s1a+qlZIWFLDQqTROPtIKeHVMbI0/Qmjh8FvARRBT0W2ENkGljoScU7Q+xb5iisLGdZaKCaABTTabKbvWhgHMSNtBkzG+p/UMIivUBTgq0wpU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Deprecate checkpatch.pl --file
Date: Tue, 8 Jan 2008 21:27:21 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: Daniel Walker <dwalker@mvista.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, apw@shadowen.org,
       akpm@linux-foundation.org
References: <20080108161403.GA11632@basil.nowhere.org> <1199811033.1756.29.camel@imap.mvista.com> <20080108175347.GA25968@uranus.ravnborg.org>
In-Reply-To: <20080108175347.GA25968@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801082127.21602.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 January 2008, Sam Ravnborg wrote:
> On Tue, Jan 08, 2008 at 08:50:33AM -0800, Daniel Walker wrote:
> > 
> > On Tue, 2008-01-08 at 17:14 +0100, Andi Kleen wrote:
> > 
> > 
> > > +if ($file) {
> > > +	print <<EOL
> > > +WARNING: Using --file mode. Please do not send patches to linux-kernel
> > > +that change whole existing files if you did not significantly change most
> > > +of the the file for other reasons anyways or just wrote the file newly
> > > +from scratch. Pure code style patches have a significant cost in a
> > > +quickly changing code base like Linux because they cause rejects
> > > +with other changes.
> > > +If you're sure you want to use whole file mode please use --file-force
> > > +EOL
> > > +;
> > > +	exit(1);

I'm not against the patch (although --file to --file-force parameter change
seems unnecessary and the warning should be toned down) but I think that
cleanup patches have been demonized out of proportion recently on LKML.

> > Can't say I like this too much .. It sounds like your telling people to
> > stop sending cleanup patches, which doesn't make much sense .. We want a
> > clean kernel .. Or at least I do ..

Seconded, also if this is what people like to work on we shouldn't be trying
to stop them but point them into the direction where their work could be more
productive in "the big picture" context.

> It is a simple pain/benefit issue.
> Fixing the 25 errors and 13 warnings in kernel/profile.c may look
> like an easy task but then we put additional burden on the 10 people
> that have patches pending for this file.

OTOH there is a lot of old/legacy code that almost nobody is touching where
cleanup would be appreciated (it is quite likely that somebody will notice
and fix a bug or two in the process).

> It is the same reason why we do not run a 'kill-trailing-whitespace'
> on the full kernel tree.

Agreed but we sometimes accept per file whitespace cleanups.

The important thing here is "common sense".  Sending a big patch series
of "checkpatch.pl fixes" for kernel/* files is certainly not a good thing.
Core code has a lot of high-profile people looking over it so you will be
just interfering with their changes.

However if somebody do such fixes for some old/orphaned driver _and_ also
fix other things at the same time then everything is sweet from my POV. :)

Thanks,
Bart
