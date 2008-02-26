Return-Path: <linux-kernel-owner+w=401wt.eu-S1756466AbYBZHoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466AbYBZHoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 02:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbYBZHoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 02:44:07 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:38171 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044AbYBZHoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 02:44:05 -0500
Message-ID: <47C3C33F.1070908@garzik.org>
Date: Tue, 26 Feb 2008 02:43:59 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Chris Wedgwood <cw@f00f.org>
Subject: Re: Proposal for "proper" durable fsync() and fdatasync()
References: <20080226072649.GB30238@shareable.org>
In-Reply-To: <20080226072649.GB30238@shareable.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier wrote:
> By durable, I mean that fsync() should actually commit writes to
> physical stable storage,

Yes, it should.


> I was surprised that fsync() doesn't do this already.  There was a lot
> of effort put into block I/O write barriers during 2.5, so that
> journalling filesystems can force correct write ordering, using disk
> flush cache commands.
> 
> After all that effort, I was very surprised to notice that Linux 2.6.x
> doesn't use that capability to ensure fsync() flushes the disk cache
> onto stable storage.

It's surprising you are surprised, given that this [lame] fsync behavior 
has remaining consistently lame throughout Linux's history.

[snip huge long proposal]

Rather than invent new APIs, we should fix the existing ones to _really_ 
flush data to physical media.

Linux should default to SAFE data storage, and permit users to retain 
the older unsafe behavior via an option.  It's completely ridiculous 
that we default to an unsafe fsync.

And [anticipating a common response from others] it is completely 
irrelevant that POSIX fsync(2) permits Linux's current behavior.  The 
current behavior is unsafe.

Safety before performance -- ESPECIALLY when it comes to storing user data.

Regards,

	Jeff (Linux ATA driver dude)


