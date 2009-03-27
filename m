Return-Path: <linux-kernel-owner+w=401wt.eu-S1750738AbZC0WVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750738AbZC0WVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 18:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbZC0WVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 18:21:21 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35404 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598AbZC0WVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 18:21:21 -0400
Message-ID: <49CD5143.1060904@garzik.org>
Date: Fri, 27 Mar 2009 18:20:51 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090327112438.GQ6239@mit.edu> <20090327145156.GB24819@srcf.ucam.org> <20090327150811.09b313f5@lxorguk.ukuu.org.uk> <20090327152221.GA25234@srcf.ucam.org> <20090327161553.31436545@lxorguk.ukuu.org.uk> <20090327162841.GA26860@srcf.ucam.org> <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk> <20090327170208.GA27646@srcf.ucam.org> <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain> <49CD2C47.4040300@garzik.org> <20090327200118.GA6239@mit.edu>
In-Reply-To: <20090327200118.GA6239@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Fri, Mar 27, 2009 at 03:43:03PM -0400, Jeff Garzik wrote:
>> On the other side of the coin, major desktop apps Firefox and  
>> Thunderbird already use it:  Firefox uses sqlite to log open web pages  
>> in case of a crash, and sqlite in turn sync's its journal as any good  
>> database app should.  [I think tytso just got them to use fdatasync and  
>> a couple other improvements, to make this not-quite-so-bad]
> 
> I spent a very productive hour-long conversation with the Sqlite
> maintainer last weekend.  He's already checked in a change to use
> fdatasync() everywhere, and he's looking into other changes that would
> help avoid needing to do a metadata sync because i_size has changed.
> One thing that will definitely help is if applications send the
> sqlite-specific SQL command "PRAGMA journal_mode = PERSIST;" when they
> first startup the Sqlite database connection.  This will cause Sqlite
> to keep the rollback journal file to stick around instead of being
> deleted and then recreated for each Sqlite transaction.  This avoids
> at least one fsync() of the directory containing the rollback journal
> file.  Combined with the change in Sqlite's development branch to use
> fdatasync() everwhere that fsync() is used, this should definitely be
> a huge improvement.
> 
> In addition, Firefox 3.1 is reportedly going to use an union of an
> on-disk database and an in-memory database, and every 15 or 30 minutes
> or so (presumably tunable via some config parameter), the in-memory
> database changes will be synched out to the on-disk database.  This
> will *definitely* help a lot, and also help improve SSD endurance.

Definitely, though it will be an interesting balance once user feedback 
starts to roll in...

Firefox started doing this stuff because, when it or the window system 
or OS crashed, users like my wife would not lose the 50+ tabs they've 
opened and were actively using.  :)

So it's hard to see how users will react to going back to the days when 
firefox crashes once again mean lost work.  [referring to the 15-30 min 
delay, not fsync(2)]

	Jeff




