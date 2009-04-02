Return-Path: <linux-kernel-owner+w=401wt.eu-S933094AbZDBXih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094AbZDBXih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 19:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765463AbZDBXiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 19:38:25 -0400
Received: from thunk.org ([69.25.196.29]:42519 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765895AbZDBXiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 19:38:23 -0400
Date: Thu, 2 Apr 2009 19:38:06 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
Cc: Ray Lee <ray-lk@madrabbit.org>, david@lang.hm,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Sitsofe Wheeler <sitsofe@yahoo.com>, Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
Message-ID: <20090402233806.GG9870@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
	Ray Lee <ray-lk@madrabbit.org>, david@lang.hm,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Sitsofe Wheeler <sitsofe@yahoo.com>,
	Alberto Gonzalez <info@gnebu.es>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20090401015010.GB4529@mit.edu> <20090401052050.GA20456@sucs.org> <20090401151219.GA12285@srcf.ucam.org> <20090401173521.GA15423@mit.edu> <20090401174336.GA14726@srcf.ucam.org> <alpine.DEB.1.10.0904021116500.28893@asgard.lang.hm> <20090402182925.GA4502@srcf.ucam.org> <alpine.DEB.1.10.0904021134560.28893@asgard.lang.hm> <2c0942db0904021307w2c311dc2s9bf31c9ed3c1e6ba@mail.gmail.com> <49D5273B.60806@ursus.ath.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D5273B.60806@ursus.ath.cx>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 10:59:39PM +0200, Andreas T.Auer wrote:
> 
> Yes, but a lot of users (and I assume >90% of POP3 users) don't use this
> option.
> 

Sometimes, the filesystem isn't the best place to solve all problems.  

What's been frustrating about this whole controversy is this implicit
assumptions that users and applications should never change, and the
filesystem should magically accomodate and Do The Right Thing.

If you're *never* going want to risk ever losing mail, then fine,
fsync() it to disk before you send the POP3 DELETE command.  If you
don't like the performance delay, or the battery consumption
implications, tough.  I'm fresh out of magic pixie dust.

If the application is smarter about not deleting the messages from the
POP spool, then you can afford not to fsync().  But (oh, horrors!) it
might involve making the application smarter, and playing a
synchronization game between the local POP spool and IMAP.  It's more
efficient to do this with IMAP, but there are POP clients that do this.

If you are a mail client developer, and the user says, "I want the
advantages of IMAP, but I refuse to switch to an ISP that provides
IMAP; you must give me *all* the advantages IMAP even though I'm using
POP3", you'd probably tell the user, "Yes, and do you want a pony,
too?"

The problem is, this is what the application programmers are telling
the filesystem developers.  They refuse to change their programs; and
the features they want are sometimes mutually contradictory, or at
least result in a overconstrained problem --- and then they throw the
whole mess at the filesystem developers' feet and say, "you fix it!"

I'm not saying the filesystems are blameless, but give us a little
slack, guys; we NEED some help from the application developers here.

      	    	      	       		   	      - Ted
