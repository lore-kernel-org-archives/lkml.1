Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbYEZSXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbYEZSXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 14:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754452AbYEZSXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 14:23:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48300 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059AbYEZSXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 14:23:41 -0400
Date: Mon, 26 May 2008 20:23:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Oliver Neukum <oliver@neukum.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Top 10 bugs/warnings for the week of March 23rd, 2008
Message-ID: <20080526182323.GA20719@elte.hu>
References: <4836EE8C.1010200@linux.intel.com> <20080526164858.GA24098@elte.hu> <20080526170147.GB9893@mit.edu> <200805261909.59032.oliver@neukum.org> <e2e108260805261028o204d4fc7l3f20ad3919cf778b@mail.gmail.com> <20080526173848.GM32407@duck.suse.cz> <20080526175039.GC11330@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080526175039.GC11330@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Theodore Tso <tytso@mit.edu> wrote:

> > > Looking at the filesystem UUID could help -- this is an ID that is 
> > > present as data on the disk, and that is even independent of the 
> > > bus type. See also /dev/disk/by-uuid.
> >   Yes, but as Oliver wrote if someone modified the filesystem in the mean
> > time, you won't notice it - UUID doesn't help here.
> 
> That part you could figure out in userspace, by looking at the last 
> mount and last modified time in the superblock.  But the problem is 
> it's too late.  If you had buffers which had been "in flight" at the 
> time when the USB stick was pulled, the kernel isn't going to be able 
> to send them to the new instantiation of the device for the freshly 
> installed USB stick.  And I don't think we want to put 
> filesystem-specific UUID and superblock parsing code in the generic 
> USB layer!

yeah, i agree it's all ugly - but it's really our making not the user's 
;-)

i think we could and should go to quite some length to properly support 
a rather benign-appearing usecase such as the user removing stuff from a 
modern computer (stuff that is not specifically bolted down that is). 
Violating a few artificial abstraction layers within the kernel is a lot 
better than losing user data, IMHO.

	Ingo
