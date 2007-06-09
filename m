Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbXFIQTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbXFIQTO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 12:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbXFIQS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 12:18:59 -0400
Received: from smtpout.mac.com ([17.250.248.186]:51371 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589AbXFIQS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 12:18:58 -0400
In-Reply-To: <Pine.LNX.4.64.0706082207260.6675@asgard.lang.hm>
References: <20070514110607.549397248@suse.de> <200706042303.28785.agruen@suse.de> <1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil> <200706090003.57722.agruen@suse.de> <20070609001703.GA17644@kroah.com> <Pine.LNX.4.64.0706082207260.6675@asgard.lang.hm>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <23C85F2D-9715-4C9B-BD4D-B7186A71F33D@mac.com>
Cc: Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, Pavel Machek <pavel@ucw.cz>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Date: Sat, 9 Jun 2007 12:18:52 -0400
To: david@lang.hm
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 09, 2007, at 01:18:40, david@lang.hm wrote:
> SELinux is like a default allow IPS system, you have to describe  
> EVERYTHING to the system so that it knows what to allow and what to  
> stop.

WRONG.  You clearly don't understand SELinux at all.  Try booting in  
enforcing mode with an empty policy file (well, not quite empty,  
there are a few mandatory labels you have to create before it's a  
valid policy file).  /sbin/init will load the initial policy, attempt  
to re-exec() itself... and promptly grind to a halt.  End-of-story.

Typical "targetted" policies leave all user logins as unrestricted,  
adding security for daemons but not getting in the way of users who  
would otherwise turn SELinux off.  On the other hand, a targeted  
policy has a "trusted" type for user logins which is explicitly  
allowed access to everything.

That said, if you actually want your system to *work* with any  
default-deny policy then you have to describe EVERYTHING anyways.   
How exactly do you expect AppArmor to "work" if you don't allow users  
to run "/bin/passwd", for example.

Cheers,
Kyle Moffett

