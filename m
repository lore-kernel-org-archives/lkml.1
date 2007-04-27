Return-Path: <linux-kernel-owner+w=401wt.eu-S1755426AbXD0Gur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbXD0Gur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 02:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbXD0Gur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 02:50:47 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42466 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426AbXD0Guq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 02:50:46 -0400
Date: Fri, 27 Apr 2007 09:50:44 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <1177655661.4737.106.camel@nigel.suspend2.net>
Message-ID: <Pine.LNX.4.64.0704270939460.20493@sbz-30.cs.Helsinki.FI>
References: <1177567481.5025.211.camel@nigel.suspend2.net> 
 <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com> 
 <1177573348.5025.224.camel@nigel.suspend2.net> 
 <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org> 
 <1177617379.4737.29.camel@nigel.suspend2.net> 
 <Pine.LNX.4.64.0704270750320.13539@sbz-30.cs.Helsinki.FI> 
 <1177654110.4737.91.camel@nigel.suspend2.net> 
 <Pine.LNX.4.64.0704270910190.18521@sbz-30.cs.Helsinki.FI>
 <1177655661.4737.106.camel@nigel.suspend2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Nigel Cunningham wrote:
> Sorry Pekka, but that's just broken.

It certainly isn't.

On Fri, 27 Apr 2007, Nigel Cunningham wrote:
> It implies firstly that we tell all userspace programs "I'm sorry, but
> I'm suspending at the moment. Can you tip toe quietly around while I do
> it?" You can't seriously expect every userspace program to be modified
> to adjust it's behaviour according to whether we're writing a snapshot
> to disk at the moment or not.

You don't need to modify other programs. You just need to display the 
progress bar and block _user input_. I don't even claim to know X, but I 
would be extremely surprised if you technically can't say "don't let 
the user touch any other windows except this one." The user couldn't care 
less whether tasks are frozen or not by the kernel. What matters is that 
the user can't shoot himself in the foot while snapshotting.

Furthermore, we probably do need to do other things to ensure safety, like 
remounting filesystems read-only but again, this has nothing to do with 
snapshotting per se. What the kernel needs to worry about is (1) providing 
an atomic snapshot that is consistent and (2) resuming to that snapshot 
safely. If the _user_ loses data that was generated between snapshot + 
shutdown, it's absolutely no concern for the snapshot operation!

On Fri, 27 Apr 2007, Nigel Cunningham wrote:
> It also implies that we can prepare a snapshot and then happily have the
> contents of the disk change so that they don't match the superblock and
> other filesystem details we just saved in the snapshot. We can't. At
> least not without modifying all the filesystems so that (at a minimum)
> they know how to throw away all the metadata they have at resume time
> and reread it from disk.

But you just explained how we can! We shouldn't bend over backwards for 
snapshotting just because the filesystems don't currently support 
something we need.

On Fri, 27 Apr 2007, Nigel Cunningham wrote:
> By the way, sorry. This email feels like it is pouring a lot of cold
> water on your ideas. I don't want to be negative!

Don't worry, I am used to cold water :-).

				Pekka
