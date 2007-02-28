Return-Path: <linux-kernel-owner+w=401wt.eu-S932226AbXB1S1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226AbXB1S1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 13:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932228AbXB1S1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 13:27:53 -0500
Received: from smtp.osdl.org ([65.172.181.24]:38138 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932226AbXB1S1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 13:27:52 -0500
Date: Wed, 28 Feb 2007 10:28:10 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] HID and USB HID update for 2.6.21-rc2
In-Reply-To: <Pine.LNX.4.64.0702281013190.12485@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702281022380.12485@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702281114420.4255@jikos.suse.cz>
 <Pine.LNX.4.64.0702280903010.12485@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702281814380.4255@jikos.suse.cz>
 <Pine.LNX.4.64.0702280931480.12485@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702281837200.4255@jikos.suse.cz>
 <Pine.LNX.4.64.0702281013190.12485@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 28 Feb 2007, Linus Torvalds wrote:
> 
> In other words, there is *zero* excuse for that braindamage.

To be clear:

 - in header files, we put "common definitions":

	* #defines
	* data structure declarations
	* external function and data declarations
	* inline functions ("nicer but otherwise equivalent to a #define")

 - but we do *not* put

	* actual real code
	* actual real data

   because those go into C files.

Yes, yes, all rules have exceptions, and sometimes we have ugly header 
files. For an example of a pre-existing ugly header file that breaks these 
rules, just look at <asm-i386/bugs.h> for example. Yeah, it only gets 
included from one place, but it *still* shouldn't have code in it. It grew 
over time, and none of the individual events were ever really big enough 
for anybody to say "ok, we should clean this up and create a bugs.c file 
in arch/i386/kernel".

I'm sure there are other examples of the exceptions too. But I do not want 
to add *new* ugly stuff, and I certainly refuse to do it after we're 
already long past a merge window.

		Linus
