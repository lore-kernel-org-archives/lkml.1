Return-Path: <linux-kernel-owner+w=401wt.eu-S1755143AbYKJRgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbYKJRgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 12:36:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbYKJRgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 12:36:37 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:37180 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729AbYKJRgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 12:36:36 -0500
Date: Mon, 10 Nov 2008 18:35:04 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Slow file transfer speeds with CFQ IO scheduler in some cases
Message-ID: <20081110173504.GL26778@kernel.dk>
References: <4917263D.2090904@telenet.dn.ua> <20081110104423.GA26778@kernel.dk> <x493ahzsn8p.fsf@segfault.boston.devel.redhat.com> <20081110135618.GI26778@kernel.dk> <49186C5A.5020809@telenet.dn.ua>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49186C5A.5020809@telenet.dn.ua>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10 2008, Vitaly V. Bursov wrote:
> Jens Axboe wrote:
> > On Mon, Nov 10 2008, Jeff Moyer wrote:
> >> Jens Axboe <jens.axboe@oracle.com> writes:
> >>
> >>> http://bugzilla.kernel.org/attachment.cgi?id=18473&action=view
> >> Funny, I was going to ask the same question.  ;)  The reason Jens wants
> >> you to try this patch is that nfsd may be farming off the I/O requests
> >> to different threads which are then performing interleaved I/O.  The
> >> above patch tries to detect this and allow cooperating processes to get
> >> disk time instead of waiting for the idle timeout.
> > 
> > Precisely :-)
> > 
> > The only reason I haven't merged it yet is because of worry of extra
> > cost, but I'll throw some SSD love at it and see how it turns out.
> > 
> 
> Sorry, but I get "oops" same moment nfs read transfer starts.
> I can get directory list via nfs, read files locally (not
> carefully tested, though)
> 
> Dumps captured via netconsole, so these may not be completely accurate
> but hopefully will give a hint.

Interesting, strange how that hasn't triggered here. Or perhaps the
version that Jeff posted isn't the one I tried. Anyway, search for:

        RB_CLEAR_NODE(&cfqq->rb_node);

and add a

        RB_CLEAR_NODE(&cfqq->prio_node);

just below that. It's in cfq_find_alloc_queue(). I think that should fix
it.

-- 
Jens Axboe

