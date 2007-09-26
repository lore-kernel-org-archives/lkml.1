Return-Path: <linux-kernel-owner+w=401wt.eu-S1759017AbXIZUbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017AbXIZUbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 16:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbXIZUa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 16:30:59 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:14753 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbXIZUa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 16:30:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=lRl01231AXy+tJ49OShv5vf/gBhNK0nGKkL2yFjwSR1LeNWl1asQrONA3L4nKCEVPtOkosWU+wDDurORnJJ5SvHVJ6szZZBUYvYFJ835yRlti13ugVt27JnMrN1LP5wnWQt9OZuVoyNV/4rM57A5pLSlGa4Lp4mdQw3dZA0We2M=
Date: Wed, 26 Sep 2007 16:30:36 -0400
To: Pavel Machek <pavel@ucw.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@suspend2.net,
       "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
Message-ID: <20070926203036.GF31759@nineveh.local>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	"Eric W. Biederman" <ebiederm@xmission.com>, nigel@suspend2.net,
	"Huang, Ying" <ying.huang@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
	linux-pm@lists.linux-foundation.org,
	Kexec Mailing List <kexec@lists.infradead.org>
References: <1190266447.21818.17.camel@caritas-dev.intel.com> <200709211225.25874.nigel@nigel.suspend2.net> <1190342757.21818.75.camel@caritas-dev.intel.com> <200709211259.00195.nigel@nigel.suspend2.net> <m1r6ksiq27.fsf@ebiederm.dsl.xmission.com> <20070921094512.GA20149@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070921094512.GA20149@elf.ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: jfannin@gmail.com (Joseph Fannin)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 11:45:12AM +0200, Pavel Machek wrote:
> Hi!
> > >
> > > Sounds doable, as long as you can cope with long command lines (which
> > > shouldn't be a biggie). (If you've got a swapfile or parts of a swap
> > > partition already in use, it can be quite fragmented).
> >
> > Hmm.  This is an interesting problem.  Sharing a swap file or a swap
> > partition with the actual swap of user space pages does seem to be
> > a limitation of this approach.
> >
> > Although the fact that it is simple to write to a separate file may
> > be a reasonable compensation.
>
> I'm not sure how you'd write it to a separate file. Notice that kjump
> kernel may not mount journalling filesystems, not even
> read-only. (Ext3 replays journal in that case). You could pass block
> numbers from the original kernel...

    The ext3 thing is a bug, the case for which I don't think has been
adequately explained to the ext[34] folks.  There should be at least a
no_replay mount flag available, or something.  It has ramifications
for more than just hibernation.

    And yeah, I'm gonna bring up the swap files thing again.  If you
can hibernate to a swap file, you can hibernate to a dedicated
hibernation file, and vice versa.

    If you can't hibernate to a swap file, then swap files are
effectively unsupported for any system you might want to hibernate.
<handwave> I wonder what embedded folks would think about that
</handwave>.

    But, in my ignorance, I'm not sure even fixing the ext3 bug will
guarantee you consistent metadata so that you can handle a
swap/hibernate file.  You can do a sync(), but how do you make that
not race against running processes without the freezer, or blkdev
snapshots?

    I guess uswsusp and the-patch-previously-known-as-suspend2 handle
this somehow, though.

   (It's that same ignorance that has me waiting for someone with
established credit with kernel people to make that argument for the
ext3 bug, so I can hang my own reasons for thinking that it's bad off
of theirs).

--
Joseph Fannin
jfannin@gmail.com

