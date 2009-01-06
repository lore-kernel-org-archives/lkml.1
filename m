Return-Path: <linux-kernel-owner+w=401wt.eu-S1751873AbZAFP62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbZAFP62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 10:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbZAFP5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 10:57:51 -0500
Received: from THUNK.ORG ([69.25.196.29]:48367 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035AbZAFP5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 10:57:50 -0500
Date: Tue, 6 Jan 2009 10:57:29 -0500
From: Theodore Tso <tytso@mit.edu>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Rob Landley <rob@landley.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@suse.cz>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       Duane Griffin <duaneg@dghda.com>, Valdis.Kletnieks@vt.edu,
       Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
Message-ID: <20090106155729.GA10034@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andi Kleen <andi@firstfloor.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Rob Landley <rob@landley.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Pavel Machek <pavel@suse.cz>, Sitsofe Wheeler <sitsofe@yahoo.com>,
	Duane Griffin <duaneg@dghda.com>, Valdis.Kletnieks@vt.edu,
	Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org
References: <fa.pmCH9X+XujDl6RH6/TpkNtsTnbk@ifi.uio.no> <200901042149.27655.rob@landley.net> <20090105111913.47a8d1a5@lxorguk.ukuu.org.uk> <200901051300.09169.rob@landley.net> <yq1ocyl1rkq.fsf@sermon.lab.mkp.net> <20090106104146.GD6700@merlin.emma.line.org> <20090106153020.GB13086__11022.1833143898$1231255950$gmane$org@mit.edu> <87k5984f4e.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k5984f4e.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 04:40:33PM +0100, Andi Kleen wrote:
> > Well, Kurt Garloff wrote that program years and years ago.  I'm sure
> > if someone created patches he'd probably accept them, though.  It's
> > still the best program I've found for doing image backups in
> > catastrophic situations.
> 
> Better would be just to incorporate the functionality as an option
> into standard GNU dd. Then everyone would easily have access to it.

I'm not sure whether the GNU coreutils maintainer would be willing to
accept a series of Linux-specific interfaces, but dd_rescue also has
the advantage that it uses a large blocksize for speed, but when an
error is returned, it backs off to a small block size to recovery the
maximum amount of data, and then later returns to the large block
size.  (Ideally, it should be able to query the disk drive to
determine its internal block size, and use that for the smaller block
size, but I'm not sure if there's a standardized way that value is
exposed by HDD's or SDD's.)

The dd_rescue program also has a progress bar, which as we all know
makes things go faster :-), and is useful because it means the user
knows how much of the disk has been copied, and whether he/she should
go to sleep for the night, or grab a cup of coffee or beer.  Its user
interface is also much simpler, and it's much easier to interrupt it
and start it up again where it left off.  (You can do this with dd,
but the average inexperienced user will be horribly confused by the dd
man page, and might easily screw up or skip one of the seek or skip
options.)

Of course, the right answer is to pursue both paths, although my
experiences getting changes into the core/file/shell-utils has been
frustrating and unpleasant, although granted that was over ten years
ago, and hopefully the maintainer has been replaced since then by one
who is more responsive.  OTOH, Kurt's a good guy, and would probably
be willing to accept patches to improve dd_rescue.

						- Ted
