Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbYHCBhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbYHCBhM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 21:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbYHCBhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 21:37:00 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:27418 "EHLO
	pd7mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751516AbYHCBg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 21:36:59 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=Kzvv9J8FBGoA5Q_Uz3YA:9 a=ogobqr4psVy2MerJqr0A:7 a=9qOOT9UHCdaM68xlmbcWOLAcuPIA:4
Message-ID: <48950B8F.70602@shaw.ca>
Date: Sat, 02 Aug 2008 19:36:15 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Brian Beattie <beattie@beattie-home.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: ioctl's suck?
References: <fa.pDV0CxkUWw00OFrnybFqbUSeaQA@ifi.uio.no>
In-Reply-To: <fa.pDV0CxkUWw00OFrnybFqbUSeaQA@ifi.uio.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Beattie wrote:
> The other day Linus (I think) made the statement, that I don't disagree
> with, that I will parapharse as "ioctl's suck".  If I recall correctly
> and understand he was saying that a device that uses ioctls is broken.
> (this is my paraphrase and if it offends anybody it is my fault not the
> original author's).
> 
> This got me to thinking about a device driver that I'm working on.
> Currently I have some ioctls to handle status and out of band messages
> and I'm wondering about eliminating the ioctls.  I'm wondering if
> anybody has any ideas or opinions that they would like to share, about
> just what i wrong with ioctls and/or how to avoid them.

As I see it the main problems are:

-Unless the ioctl parameter structures are laid out carefully, you end 
up with problems like different structure layouts between 32/64-bit 
processes, etc.

-They can't really be used by anything other than a C or C++ program. 
Anything else (shell script, Python, Java, etc.) is pretty much out of 
luck unless it can use a C shim layer of some sort.

> 
> I can see a number of problems with ioctls that I can'tr quite put into
> words.
> 
> I could add a control device and pass ascii strings for status and OOB
> messages, would that be an improvement?

Quite likely. For something like a status that's being read out of the 
device, a sysfs file would seem a more logical choice. If you're sitting 
there waiting for messages to show up, though, a separate device node 
might be better.
