Return-Path: <linux-kernel-owner+w=401wt.eu-S1752377AbZKLIwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbZKLIwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 03:52:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbZKLIwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 03:52:43 -0500
Received: from gw1.transmode.se ([213.115.205.20]:57227 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbZKLIwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 03:52:43 -0500
In-Reply-To: <20091111152445.7d2f8643.akpm@linux-foundation.org>
References: <1257762136-17593-1-git-send-email-Joakim.Tjernlund@transmode.se> <20091111152445.7d2f8643.akpm@linux-foundation.org>
Subject: Re: [PATCH] zlib: Optimize inffast even more
X-KeepSent: 7CD0497E:D92BC1B1-C125766C:0028EF03;
 type=4; name=$KeepSent
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
X-Mailer: Lotus Notes Release 8.5.1 September 28, 2009
Message-ID: <OF7CD0497E.D92BC1B1-ONC125766C.0028EF03-C125766C.0030A731@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.com>
Date: Thu, 12 Nov 2009 09:51:25 +0100
X-MIMETrack: Serialize by Router on sesr04/Transmode(Release 8.5 HF964|October 21, 2009) at
 2009-11-12 09:52:47
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote on 12/11/2009 00:24:45:
>
> On Mon, 9 Nov 2009 11:22:16 +0100
> Joakim Tjernlund <Joakim.Tjernlund@transmode.se> wrote:
>
> > This improves zlib: Optimize inffast when copying direct from output
> > and gives another 3-4% improvement for my MPC8321 target.
> > Does not need CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS,
> > uses get_unaligned() but only in one place.
> > The copy loop just above this one can also use this
> > optimization, but I havn't done so as I have not tested if it
> > is a win there too.
> >
> > Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
> > ---
> >
> >  Someone with a little endian target should test too.
>
> eh?  That requires a PC.  Can't you test it??

It needs something that actually uses the inflate too on that PC and
I don't have that handy.
Anyhow, I downloaded zip and made the changes and tested a little, found
a problem. Will resend a new patch with everything in it soon.

