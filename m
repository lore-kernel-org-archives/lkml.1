Return-Path: <linux-kernel-owner+w=401wt.eu-S1757293AbZC1QLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbZC1QLt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 12:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbZC1QLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 12:11:40 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:42524 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbZC1QLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 12:11:40 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49CE4B99.1090006@s5r6.in-berlin.de>
Date: Sat, 28 Mar 2009 17:08:57 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090323 SeaMonkey/1.1.15
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org> <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu> <20090327145156.GB24819@srcf.ucam.org> <20090327150811.09b313f5@lxorguk.ukuu.org.uk> <20090327152221.GA25234@srcf.ucam.org> <20090327161553.31436545@lxorguk.ukuu.org.uk> <20090327162841.GA26860@srcf.ucam.org> <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk> <20090327170208.GA27646@srcf.ucam.org> <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain> <49CD2C47.4040300@garzik.org> <alpine.LFD.2.00.0903271443440.3994@localhost.localdomain> <49CD4DDF.3000001@garzik.org> <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca>
In-Reply-To: <49CE3F74.6090103@rtr.ca>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
>> Well, for the time being, why not base considerations for performance,
>> interactivity, energy consumption, graceful restoration of application
>> state etc. on the assumption that kernel crashes are suitably rare?  (At
>> least on systems where data loss would be of concern.)

In more general terms:  If overall system reliability is known
insufficient, attempt to increase reliability of lower layers first.  If
this approach alone would be too costly in implementation or use, then
also look at how to increase reliability of upper layers too.

(Example:  Running a suitably reliable kernel on a desktop for
"mission-critical web browsing" is possible at low cost, at least if
early decisions, e.g. for well-supported video hardware, went right.)


Mark Lord wrote:
> The better solution seems to be the rather obvious one:
> 
>   the filesystem should commit data to disk before altering metadata.
> 
> Much easier and more reliable to centralize it there, rather than
> rely (falsely) upon thousands of programs each performing numerous
> performance-killing fsync's.
> 
> Cheers

Sure.  I forgot:  Not only the frequency of I/O disruption (e.g. due to
kernel crash) factors into system reliability; the particular impact of
such disruption is a factor too.  (How hard is recovery?  Will at least
old data remain available? ...)
-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
