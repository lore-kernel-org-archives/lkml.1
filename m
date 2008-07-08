Return-Path: <linux-kernel-owner+w=401wt.eu-S1755080AbYGHVtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbYGHVtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 17:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbYGHVtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 17:49:13 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54149 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbYGHVtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 17:49:12 -0400
Date: Tue, 8 Jul 2008 23:50:02 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Altobelli, David" <david.altobelli@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>
Subject: Re: [PATCH][resubmit] HP iLO driver
Message-ID: <20080708215002.GA18195@elf.ucw.cz>
References: <20080623160052.GA7616@ldl.fc.hp.com> <20080627191458.GA10872@ucw.cz> <CF70AA892F109448AEA269483B3A983903BB8CE586@G1W1215.americas.hpqcorp.net> <20080707160658.GB1794@elf.ucw.cz> <CF70AA892F109448AEA269483B3A983903BB8CEA25@G1W1215.americas.hpqcorp.net> <20080708072152.GD1761@elf.ucw.cz> <20080708073818.GA14245@elf.ucw.cz> <CF70AA892F109448AEA269483B3A983903BB8CEFC4@G1W1215.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CF70AA892F109448AEA269483B3A983903BB8CEFC4@G1W1215.americas.hpqcorp.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-07-08 14:48:00, Altobelli, David wrote:
> Pavel Machek wrote:
> > It probably does configure passwords on the management processor, for
> > example?
> >
> > And for that functionality, something like
> >
> > echo new_password > /sys/hpilo/admin/password
> >
> > would make sense, right? Except that your interface is more like "echo
> > ^%TEWFSGFSDF^%EW&^Tadmin^*&S^F&*SDYF*&SDYF*&YE*Wnew_password(*
> > &DF&S^DF*&DS^F*&S
> >> /dev/hpilo/d0ccb0", right? (And except that you consider exact
> > string to echo to change password "proprietary secret").
> >
> > We'd like to have the first interface, but unfortunately we do not
> > know enough about hpilo to even ask for better interface.
> 
> Is the first interface really preferrable?  How does that extend
> to commands that need to return data?  Do we want to manage 30 different
> commands in the kernel?  New functionality would require kernel
> updates.

Could you provide the list of commands (at least) so we can be more
concrete?

Yes, I believe we do want to have 30 commands it kernel, because it
will allow same userland to work on HP machines, AMD machines, etc...

(I assume management processors have pretty similar functionality
accross vendors, right?)

> It seems much cleaner to keep the kernel interface simple and opaque
> (ie read/write), and handle the details of the commands in user space.
> From my limited understanding, I thought that was a common goal here:
> move what you can to userspace.

We are not _that_ extreme. Yes, keep stuff in userspace is important,
but "hide hardware differences" is more important goal.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
