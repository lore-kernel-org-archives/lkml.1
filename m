Return-Path: <linux-kernel-owner+w=401wt.eu-S1754252AbZC2Ah2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbZC2Ah2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 20:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082AbZC2AhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 20:37:13 -0400
Received: from mail.lang.hm ([64.81.33.126]:52932 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbZC2AhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 20:37:12 -0400
Date: Sat, 28 Mar 2009 17:33:58 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Jeff Garzik <jeff@garzik.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <49CD7B10.7010601@garzik.org>
Message-ID: <alpine.DEB.1.10.0903281726100.22577@asgard.lang.hm>
References: <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org> <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu> <20090327145156.GB24819@srcf.ucam.org> <20090327150811.09b313f5@lxorguk.ukuu.org.uk>
 <20090327152221.GA25234@srcf.ucam.org> <20090327161553.31436545@lxorguk.ukuu.org.uk> <20090327162841.GA26860@srcf.ucam.org> <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk> <20090327170208.GA27646@srcf.ucam.org> <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain>
 <49CD2C47.4040300@garzik.org> <alpine.LFD.2.00.0903271443440.3994@localhost.localdomain> <49CD4DDF.3000001@garzik.org> <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain>
 <49CD7B10.7010601@garzik.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009, Jeff Garzik wrote:

> Linus Torvalds wrote:
>> Of course, your browsing history database is an excellent example of 
>> something you should _not_ care about that much, and where performance is a 
>> lot more important than "ooh, if the machine goes down suddenly, I need to 
>> be 100% up-to-date". Using fsync on that thing was just stupid, even 
>
> If you are doing a ton of web-based work with a bunch of tabs or windows 
> open, you really like the post-crash restoration methods that Firefox now 
> employs.  Some users actually do want to checkpoint/restore their web work, 
> regardless of whether it was the browser, the window system or the OS that 
> crashed.
>
> You may not care about that, but others do care about the integrity of the 
> database that stores the active FF state (Web URLs currently open), a 
> database which necessarily changes for each URL visited.

as one of those users with many windows tabs open (a couple hundred 
normally), even the curent firefox behavior isn't good enough because it 
doesn't let me _not_ load everything back in when a link I go to triggers 
a crash in firefox every time it loads.

so what I do is do a git commit in cron every min of the history file. git 
can do the fsync as needed to get it to disk reasonably without firefox 
needing to do it _for_every_click_

like laptop mode, you need to be able to define "I'm willing to loose this 
much activity in the name of performance/power"

ted's suggestion (in his blog) to tweak fsync to 'misbehave' when laptop 
mode is enabled (only pushing data out to disk when the disk is awake 
anyway, or the time has hit) would really work well for most users. 
servers (where you have the data integrity fsync useage) don't use laptop 
mode. desktops could use 'laptop mode' with a delay of 0.5 or 1 second and 
get prety close the the guarentee that users want without a huge 
performance hit.

David Lang

>
>
> As an aside, I find it highly ironic that Firefox gained useful session 
> management around the same time that some GNOME jarhead no-op'd GNOME session 
> management[1] in X.
>
> 	Jeff
>
>
>
> [1] http://np237.livejournal.com/22014.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
