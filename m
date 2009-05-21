Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbZEUV12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbZEUV12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 17:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbZEUV1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 17:27:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45068 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753703AbZEUV1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 17:27:20 -0400
Date: Thu, 21 May 2009 17:27:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kay Sievers <kay.sievers@vrfy.org>,
       Pantelis Koukousoulas <pktoss@gmail.com>
cc: Al Viro <viro@zeniv.linux.org.uk>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: How to tell whether a struct file is held by a process?
In-Reply-To: <ac3eb2510905211407l3aec14acx2572a2ad4e675b9@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0905211724050.3914-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 May 2009, Kay Sievers wrote:

> Not sure, if we already discussed that with a conclusion: this
> "prevent access to a future device" interface needs to work at the pid
> level, or would a uid/gid check be sufficient?
> 
> Root can do all that stuff anyway, even with the locking in place.
> Uid/gid file permissions need to be applied to the "lock file", so
> specified non-root users can use that interface.
> 
> Maybe it would be good enough, to check that the one that opened the
> "lock file" has the same uid/gid as the on that tries to open the
> device when it has shown up?

I don't know; it depends on what people want.  Pantelis, would this be 
good enough for you?  That is, restrict the device either to programs 
having the same uid/gid or having the same pid as the process that 
opened the lock file?

(Note that the pid check alone isn't fully secure, since pid values get 
reused after a process ends.)

Alan Stern

