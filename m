Return-Path: <linux-kernel-owner+w=401wt.eu-S1753036AbXFIFLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbXFIFLW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 01:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbXFIFLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 01:11:14 -0400
Received: from bay0-omc2-s31.bay0.hotmail.com ([65.54.246.167]:30739 "EHLO
	bay0-omc2-s31.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751491AbXFIFLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 01:11:12 -0400
X-Originating-IP: [70.53.13.125]
X-Originating-Email: [seanlkml@sympatico.ca]
Date: Sat, 9 Jun 2007 01:10:22 -0400
From: Sean <seanlkml@sympatico.ca>
To: david@lang.hm
Cc: Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and
 manipulation,pathname matching
Message-Id: <20070609011022.ac332fc7.seanlkml@sympatico.ca>
In-Reply-To: <Pine.LNX.4.64.0706082138360.6675@asgard.lang.hm>
References: <200706042303.28785.agruen@suse.de>
	<1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil>
	<200706090003.57722.agruen@suse.de>
	<20070609001703.GA17644@kroah.com>
	<Pine.LNX.4.64.0706081757070.18969@asgard.lang.hm>
	<200706091101.JAB31303.PTNNSGtM@I-love.SAKURA.ne.jp>
	<20070608232531.d68de09f.seanlkml@sympatico.ca>
	<Pine.LNX.4.64.0706082138360.6675@asgard.lang.hm>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jun 2007 05:11:12.0182 (UTC) FILETIME=[98DB1D60:01C7AA54]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007 21:56:06 -0700 (PDT)
david@lang.hm wrote:

> 
> with AA hardlinks are effectivly different labels on the same file

So what?  SELinux can be be altered to accept whatever label you generate.
Pass it whatever label you want.

> one of the big problems with SELinux is what label to put on new files 
> (including temp files), the AA approach avoids this (frequent) problem 
> entirely. In exchange AA picks up the (infrequent) problems of bind-mounts 
> and hard-link creation. People have tried to equate these prolems to show 
> that AA has just as many problems as SELinux, but you can run systems for 
> decades without creating hard-links or bind-mounts

You are thinking about the way SELinux operates today, not how it might
operate to accommodate AA inclusion in the kernel.   Instead of SELinux
always obtaining labels from file attributes, it could ask AA for them
and you could generate them however you like.

> also you seriously misunderstand the AA approach
>
> AA does NOT try to create a security policy for every file on the system.
> 
> Instead AA policies are based on specific programs, and each policy states 
> what files that program is allowed to access.
 
please read a bit more carefully, I was responding to someone else who
made that claim.

> if you are useing AA to secure all exposed services on a box you don't 
> have to try to write a policy to describe what gcc is allowed to access 
> (unless through policy you give one of your exposed services permission to 
> run gcc, and even then I'm not sure if gcc would inherit restrictions 
> from it's parent or just use it's own)
> 
> the resulting policy is much easier to understand (and therefor check) 
> becouse it is orders of magnatude smaller then any comprehensive SELinux 
> policy.

> 
> the AA policy is also much easier to understand becouse you can look at it 
> in pieces, understand that piece, and then forget it and move on to the 
> next piece.

Nobody is asking you to change the AA policy file.  It lives in user space.
But i fail to see the problem in translating it into SELinux terms for
the user transparently.

> for example, if you write a policy for apache that limits it's access to 
> it's log files, install directories, and document root. then you write a 
> policy for your log analysis tool to access it's libraries, report 
> directories (under the apache document root) and the apache log files 
> (read only), these two policies are independant, you don't have to think 
> about one while creating the other (which you would have to do if you had 
> to put one label on apache binaries, another on normal web documents, a 
> third on the reports, a fourth on the log files, and a fifth on the 
> binaries for the log analysis tool. and this is ignoring any overlap in 
> libraries!)

Again, try to think outside the box a bit.  This isn't about using SELinux
as it exists today.  But imagine an SELinux that would ask you to 
supply a security label for each file _instead_ of looking up that label
itself.  Wouldn't that let you implement everything you wanted while still
using much of the SELinux infrastructure that is already in the kernel?

> AA also lets a sysadmin dip their toe in the water and just write a policy 
> for Apache, not for anything else, then write a policy for firefox, then 
> write a policy for their mail client, then for bittorrent, etc. there is 
> no need or push to try and secure everything all at once, and no need to 
> re-label files (and change any policies that used the old labels) when 
> you discover a new interaction.

And so it could remain;  this is about implementation, not model.

Sean
