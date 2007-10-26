Return-Path: <linux-kernel-owner+w=401wt.eu-S1758981AbXJZWkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981AbXJZWkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 18:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbXJZWkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 18:40:37 -0400
Received: from adsl-67-117-79-109.dsl.sntc01.pacbell.net ([67.117.79.109]:4470
	"EHLO aurum.uhlenkott.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbXJZWkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 18:40:36 -0400
Date: Fri, 26 Oct 2007 15:40:35 -0700
From: Jason Uhlenkott <jasonuhl@jasonuhl.org>
To: Mike Waychison <mikew@google.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/1] Drop CAP_SYS_RAWIO requirement for FIBMAP
Message-ID: <20071026224035.GB27037@aurum.uhlenkott.net>
References: <20071025230758.945535769@crlf.corp.google.com> <20071026012217.4cc30390@the-village.bc.nu> <20071026215550.GA27037@aurum.uhlenkott.net> <4722635D.901@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4722635D.901@google.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 14:59:57 -0700, Mike Waychison wrote:
> Jason Uhlenkott wrote:
> >Additionally, ext3_bmap() has this to say about it:
> >
> >        if (EXT3_I(inode)->i_state & EXT3_STATE_JDATA) {
> >                /*
> >                 * This is a REALLY heavyweight approach, but the use of
> >                 * bmap on dirty files is expected to be extremely rare:
> >                 * only if we run lilo or swapon on a freshly made file
> >                 * do we expect this to happen.
> >                 *
> >                 * (bmap requires CAP_SYS_RAWIO so this does not
> >                 * represent an unprivileged user DOS attack --- we'd be
> >                 * in trouble if mortal users could trigger this path at
> >                 * will.)
> 
> Hmm.  I don't know what the right approach to this is.  This seems to be 
> the same situation as the delayed allocation problem, no?

Yup.

> What if we just returned 0?  Tools like lilo are already doing sync(), 
> would that cause the journal to get flushed explicitly anyway?

Not sure, but I'd be pretty nervous about breaking any existing users
which aren't explicitly syncing.

Are you envisioning users who want to see where their data is landing
for performance reasons?  It seems like such users are going to have
sufficiently different desires from existing FIBMAP users (who need to
know where everything is because they intend to fiddle with the raw
device) that a different interface might be warranted.
