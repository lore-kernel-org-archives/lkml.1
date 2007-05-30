Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbXE3QBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbXE3QBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 12:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbXE3QBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 12:01:14 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752172AbXE3QBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 12:01:14 -0400
Date: Wed, 30 May 2007 09:00:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
In-Reply-To: <200705301608.28160.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.98.0705300857450.26602@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0705241931240.26602@woody.linux-foundation.org>
 <1180531067.24891.1.camel@nigel.suspend2.net> <20070530132958.GA28893@srcf.ucam.org>
 <200705301608.28160.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 May 2007, Rafael J. Wysocki wrote:
> 
> Very true.  And I think the right order should be to make the midlayers do
> this and then remove the freezer from the STR code path, not the other way
> around. :-)

Yes. After all, STR simply shouldn't _care_.

The rule should be that in a well-written setup, STR "just works" whether 
user processes are suspended or not. In other words, the whole freezing 
part isn't about STR. It should be totally immaterial.

(Of course, that assumes that the freezing is _sane_, of course: ie the 
core kernel threads shouldn't all be frozen. I think Rafael's patch to 
turn the defaults around are a big step in the right direction).

			Linus
