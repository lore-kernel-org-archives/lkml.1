Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbZAPPlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbZAPPlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 10:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbZAPPkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 10:40:35 -0500
Received: from thunk.org ([69.25.196.29]:42337 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706AbZAPPkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 10:40:33 -0500
Date: Fri, 16 Jan 2009 10:40:26 -0500
From: Theodore Tso <tytso@mit.edu>
To: Valdis.Kletnieks@vt.edu
Cc: Pavel Machek <pavel@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Takashi Sato <t-sato@yk.jp.nec.com>
Subject: Re: [PATCH] Allow SysRq emergency sync to thaw frozen filesystems
Message-ID: <20090116154026.GG10683@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Valdis.Kletnieks@vt.edu,
	Pavel Machek <pavel@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Takashi Sato <t-sato@yk.jp.nec.com>
References: <496EB639.6090800@redhat.com> <20090116084828.GB4795@atrey.karlin.mff.cuni.cz> <16406.1232119029@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16406.1232119029@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 10:17:09AM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 16 Jan 2009 09:48:28 +0100, Pavel Machek said:
> 
> > Emergency Sync should not do this. Invent another key.
> > 
> > ...because otherwise, if you hit emergency sync but the system is
> > still alive and relies on filesystem freezing, bad stuff will happen.
> 
> Under what conditions would a system be alive and relying on freezing,
> *and* an emergency thaw would be worse than whatever reason you're doing
> an emergency sync?
> 
> Hmm.. guess you *could* get into trouble if you tried to do a Sysrq-[not-s]
> and hit the wrong key - but you have the same danger if you have *any*
> sysrq- invoking an emergency_thaw and hit it by accident...

My biggest complaint is that the two operations are largely
orthogonal.  Emergency sync and unfreeze are two very different
operations, and while emergency sync is largely harmless, it just
seems really unclean to combine the two.  For one thing, it'll be
extremely non-obvious that emergency sync implies unfreeze, and
changing the sysrq help to say emergency-Sync-and-unfreeze just
screams "kludge"....

						- Ted
