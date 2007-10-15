Return-Path: <linux-kernel-owner+w=401wt.eu-S933459AbXJOSSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933459AbXJOSSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756791AbXJOSSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:18:31 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:34858 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158AbXJOSSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:18:30 -0400
Date: Mon, 15 Oct 2007 20:19:53 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Philippe Elie <phil.el@wanadoo.fr>
Cc: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Subject: Re: WANTED: kernel projects for CS students
Message-ID: <20071015181953.GA23130@uranus.ravnborg.org>
References: <20071014190128.6e3cdb44@bree.surriel.com> <20071015142352.GA21259@uranus.ravnborg.org> <20071015163154.GA2884@zaniah>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015163154.GA2884@zaniah>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 06:31:54PM +0200, Philippe Elie wrote:
> > Increase speed for a build with no updates
> > ==========================================
> > On a resonably fast machine with a decent config it takes
> > roughly 10 seconds to do a make where nothing is updated.
> > Generating one single Makefile is assumed to speed up things
> > and will in addition allow a simpler syntax as what is used today
> > for some of the uglier constructs.
> > 
> > Contact: Sam Ravnborg <sam@ravnborg.org>
> > Difficulty: 5
> > Language: Perl or C
> 
> Isn't make -j 2 or more implemented by running multiple make in sub-dirs ?
> Parallel make is more and more used even on cheap hardware.

The kernel build system supports parallel make and I guess all
kernel developers use it. People tell me that a 32 way machine is
quite good for kernel compilation.

The bottleneck is that we spawn so many make instances and each have
to read all the same makefiles and stat in total a zillion files
for a simple kernel build.

With a single Makefile we can run a single instance make where
we read all files only once and stat the same file only once.

	Sam
