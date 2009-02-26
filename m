Return-Path: <linux-kernel-owner+w=401wt.eu-S1756756AbZBZOtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbZBZOtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:49:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbZBZOtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:49:00 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:47307 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752969AbZBZOs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:48:59 -0500
Date: Thu, 26 Feb 2009 09:48:57 -0500
To: Alex Buell <alex.buell@munted.org.uk>
Cc: Michael Tokarev <mjt@tls.msk.ru>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Unused modules in 2.6.x
Message-ID: <20090226144856.GA23246@csclub.uwaterloo.ca>
References: <20090225175249.30e47b85@lithium.local.net> <49A59082.5040209@msgid.tls.msk.ru> <20090226102939.42c92d34@lithium.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226102939.42c92d34@lithium.local.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 10:29:39AM +0000, Alex Buell wrote:
> I'd have thought that hotplugging i.e. plug in an USB device in this
> case would load the modules as and when required. 
> 
> If the interface is up, then it shouldn't have to be unloaded, I think.
> I know I could just hack my initrds to remove any modules that I don't
> want loaded at bootup but surely... :-D

So how about if you plug in a usb drive, and the module is loaded to
provide disk access, but you aren't using it right now.  The next module
clean would remove the now unused module, and then when you do want to
use it, there is no longer any way to reach teh device, and since there
is no fixed device node to refer to that would cause the module to be
loaded again, now the device doesn't work.  That would be very annoying.

I think the big problem is that the kernel and the module utils can not
know if a module is actually being used or not since it is more a matter
of 'will it be needed' not 'is it in use right now'.

-- 
Len Sorensen
