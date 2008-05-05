Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565AbYEETrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565AbYEETrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbYEETr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:47:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56428
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753183AbYEETr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:47:28 -0400
Date: Mon, 05 May 2008 12:47:22 -0700 (PDT)
Message-Id: <20080505.124722.25907909.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jonathan@jonmasters.org, sam@ravnborg.org
Subject: Re: changeset: Make forced module loading optional
From: David Miller <davem@davemloft.net>
In-Reply-To: <200805060442.12440.rusty@rustcorp.com.au>
References: <200805051535.05370.rusty@rustcorp.com.au>
	<alpine.LFD.1.10.0805050957590.32269@woody.linux-foundation.org>
	<200805060442.12440.rusty@rustcorp.com.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Tue, 6 May 2008 04:42:12 +1000

> BTW, I'm fascinated and a little nausiated that you ignore initrds.  We've 
> moved half the kernel brains to userspace with udev, initrd and modules; it's 
> really unfair that you're not sharing all that why-won't-my-machine-boot 
> love.

It's pretty straightforward, if you ask me.  I avoid initrd's like
the plague too.

Building and compressing the initrd would increase my build+reboot
cycle time by at least 40%.

Add to that it's simply an enormous pain in the ass.

And for what?  I know what freakin' drivers to build statically into
my kernel.  I use raw partitions and don't use LVM, I know what
the heck my root filesystem device is named, etc.

The only thing I get "punished" for, where I am absolutely forced to
use an initrd, is when I use qlogic SCSI for the root partition, for
the firmware which we really should have kept in the tree :(

And this is not even a "licensing" issue, like it or not in-kernel
drivers are tied to specific firmware versions both from an API and
from a testing perspective.  Externalizing this is really a nightmare.

And I'm not avoiding udev by doing this.  udev works just fine if I
raw boot a kernel with all the static devices I need to get root
mounted.  All my networking etc. is modular and udev does the right
thing.

