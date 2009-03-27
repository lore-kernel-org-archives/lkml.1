Return-Path: <linux-kernel-owner+w=401wt.eu-S1760698AbZC0Tnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760698AbZC0Tnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 15:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756309AbZC0Tne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 15:43:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49708 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801AbZC0Tnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 15:43:33 -0400
Message-ID: <49CD2C47.4040300@garzik.org>
Date: Fri, 27 Mar 2009 15:43:03 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org> <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu> <20090327145156.GB24819@srcf.ucam.org> <20090327150811.09b313f5@lxorguk.ukuu.org.uk> <20090327152221.GA25234@srcf.ucam.org> <20090327161553.31436545@lxorguk.ukuu.org.uk> <20090327162841.GA26860@srcf.ucam.org> <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk> <20090327170208.GA27646@srcf.ucam.org> <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> So the fact is, "people should always use fsync" simply isn't a realistic 
> expectation, nor is it historically accurate. Claiming it is is just 
> obviously bogus. And claiming that people _should_ do it is crazy, since 
> it performs badly enough to simply not be realistic.
> 
> Alternatives should be looked at. For desktop apps, the best alternatives 
> are likely simply stronger default consistency guarantees. Exactly the 
> "we don't guarantee that your data hits the disk, but we do guarantee that 
> if you renamed on top of another file, you'll not have lost _both_ 
> contents".

On the other side of the coin, major desktop apps Firefox and 
Thunderbird already use it:  Firefox uses sqlite to log open web pages 
in case of a crash, and sqlite in turn sync's its journal as any good 
database app should.  [I think tytso just got them to use fdatasync and 
a couple other improvements, to make this not-quite-so-bad]

Thunderbird hits the disk for each email received -- always wonderful 
with those 1000-email git-commit-head downloads... :)

So, arguments about "people should..." aside, existing desktops apps 
_do_ fsync and we get to deal with the bad performance :/

	Jeff


