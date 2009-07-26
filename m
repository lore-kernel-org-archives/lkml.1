Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbZGZV1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbZGZV1s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 17:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbZGZV1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 17:27:47 -0400
Received: from vena.lwn.net ([206.168.112.25]:58951 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971AbZGZV1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 17:27:47 -0400
Date: Sun, 26 Jul 2009 15:26:55 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Should I use kmap or kmap_atomic to map user pages that will be
 written in a loop ?
Message-ID: <20090726152655.7488abe4@bike.lwn.net>
In-Reply-To: <200907252341.48526.laurent.pinchart@skynet.be>
References: <200907252341.48526.laurent.pinchart@skynet.be>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Jul 2009 23:41:47 +0200
Laurent Pinchart <laurent.pinchart@skynet.be> wrote:

> Pages will be written to from the kernel in USB interrupt context. I can then 
> either kmap_atomic() pages before copying data and kunmap_atomic() them right 
> after, or kmap() them once at the beginning of the video stream and keep them 
> mapped until the end.

Video buffers can be big, and the streaming interface requires at least
two of them.  That's a lot of kmap'd pages.  It seems to me that
kmap_atomic() is the way to go for something like this.

But, then, these are user-space buffers, and you're seemingly buffering
the data through kernel space buffers first?  It seems like using
copy_to_user() in a workqueue (or a threaded interrupt handler) might be
a more straightforward way to go, unless I'm missing something.

jon
