Return-Path: <linux-kernel-owner+w=401wt.eu-S934277AbZDHQqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934277AbZDHQqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 12:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbZDHQqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 12:46:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48668 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751415AbZDHQqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 12:46:08 -0400
Date: Wed, 8 Apr 2009 17:47:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ed Schouten <ed@FreeBSD.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Inconsistency between PTY read() return values
Message-ID: <20090408174716.6474af70@lxorguk.ukuu.org.uk>
In-Reply-To: <20090408143631.GH32098@hoeg.nl>
References: <20090408143631.GH32098@hoeg.nl>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 	-1
> 	read: Input/output error
> 
> I looked through the standards and it seems the POSIX onlinepubs don't
> mention the behaviour of pseudo-terminal master file descriptors at all.
> This means it would even be valid of we return 0x1337 or something.
> 
> But still, I think it's a little inconsistent. Most programmers would
> expect pseudo-terminal master file descriptors to behave somewhat
> similar to TTYs, even though they don't need to be. When you try to

I would argue that TTYs do behave this way. We treat the disconnect as a
hang up event. BSD sees it as EOF, Linux as hangup.

> perform a read() on the TTY after the master file descriptor gets
> closed, you get an end-of-file. You only get an EIO when trying to write
> to this descriptor.
> 
> Would it be hard to change the Linux TTY code to behave the same?

Probably not vastly so, but given it has been this way for over ten years
and causes no problems I don't think it makes sense to do so.

Alan
