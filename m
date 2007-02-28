Return-Path: <linux-kernel-owner+w=401wt.eu-S1751698AbXB1Rd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbXB1Rd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 12:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbXB1Rd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 12:33:56 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35164 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbXB1Rdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 12:33:55 -0500
Date: Wed, 28 Feb 2007 09:34:12 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] HID and USB HID update for 2.6.21-rc2
In-Reply-To: <Pine.LNX.4.64.0702281814380.4255@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0702280931480.12485@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702281114420.4255@jikos.suse.cz>
 <Pine.LNX.4.64.0702280903010.12485@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702281814380.4255@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 28 Feb 2007, Jiri Kosina wrote:
> 
> You're right that usbhid.h is not a best place for it.

"Not the best place for it" is the understatement of the year.

It's totally idiotic. 

> This IMHO just needs cleanup. Will you accept creating a separate header 
> file solely for purposes of this blacklist and related defines?

*NO*.

Dammit, we don't put static initializers in header files. We don't 
duplicate the data in every single thing that includes a header file. If 
you want to duplicate the data, you export it as a real data structure, 
and you *still* put the data structure in a .c file.

> Otherwise I will just drop this cleanup, but I still think that the 
> current situation is horrible.

WHAT CLEANUP? The thing is the anti-thesis of a "cleanup". There is no 
excuse for putting a large array in a header file and including it 
millions of times. Or even just twice. The point of a header file is to 
*declare* things, not to have big data structures in.

		Linus
