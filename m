Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbZC1L5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbZC1L5g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 07:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbZC1L50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 07:57:26 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:35712 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbZC1L5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 07:57:25 -0400
X-RZG-AUTH: :LWIQcGC8af5qXkYNYt77sURZEFmV4M3TAgvB+Qeh4tE+44JfzNXfZHm0EYHa
X-RZG-CLASS-ID: mo05
Message-ID: <49CE109F.70603@ursus.ath.cx>
Date: Sat, 28 Mar 2009 12:57:19 +0100
From: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mark Lord <lkml@rtr.ca>, Jeff Garzik <jeff@garzik.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org> <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu> <20090327145156.GB24819@srcf.ucam.org> <20090327150811.09b313f5@lxorguk.ukuu.org.uk> <20090327152221.GA25234@srcf.ucam.org> <20090327161553.31436545@lxorguk.ukuu.org.uk> <20090327162841.GA26860@srcf.ucam.org> <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk> <20090327170208.GA27646@srcf.ucam.org> <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain> <49CD2C47.4040300@garzik.org> <alpine.LFD.2.00.0903271443440.3994@localhost.localdomain> <49CD4DDF.3000001@garzik.org> <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <49CD8868.20807@rtr.ca> <alpine.LFD.2.00.0903271928340.3994@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903271928340.3994@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 28.03.2009 03:38 Linus Torvalds wrote:
> On Fri, 27 Mar 2009, Mark Lord wrote:
>  
>> Okay, I'll bite.  Exactly which version of FF has that variable?
>> Cuz it ain't in the FF 3.0.8 that I'm running here.
>>    
>
> I'd suspect that I mistyped it, but I just cut-and-pasted it from my
email
> to make sure. Maybe you did. What happens if you just write "sync" in the
> Filter: box? Nothing matches?
>
>  
No, not with my iceweasel 3.0.7 (Debian/testing).

I couldn't find anything in the Debian patch to the source code, but the
source code contains
toolkit/components/contentprefs/src/nsContentPrefService.js 733-746:

    // Turn off disk synchronization checking to reduce disk churn and
speed up
    // operations when prefs are changed rapidly (such as when a user
repeatedly
    // changes the value of the browser zoom setting for a site).
    //
    // Note: this could cause database corruption if the OS crashes or
machine
    // loses power before the data gets written to disk, but this is
considered
    // a reasonable risk for the not-so-critical data stored in this
database.
    //
    // If you really don't want to take this risk, however, just set the
    // toolkit.storage.synchronous pref to 1 (NORMAL synchronization) or 2
    // (FULL synchronization), in which case
mozStorageConnection::Initialize
    // will use that value, and we won't override it here.
    if (!this._prefSvc.prefHasUserValue("toolkit.storage.synchronous"))
      dbConnection.executeSimpleSQL("PRAGMA synchronous = OFF");

Probably they preferred the default value "off" so much that they even
dropped the entry in standard configuration.
> Do you see firefox pausing a lot under disk load?
I see iceweasel pausing/blocking a lot when loading stalling webpages,
but that's a different topic.



