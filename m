Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbYHCMuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbYHCMuH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 08:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbYHCMtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 08:49:55 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:49690 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbYHCMty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 08:49:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18581.43362.460694.60862@stoffel.org>
Date: Sun, 3 Aug 2008 08:49:38 -0400
From: "John Stoffel" <john@stoffel.org>
To: Keith Packard <keithp@keithp.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
In-Reply-To: <1217631718.23437.290.camel@koto.keithp.com>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	<1217573919-7496-2-git-send-email-eric@anholt.net>
	<20080801205052.GA28747@infradead.org>
	<1217631718.23437.290.camel@koto.keithp.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Keith" == Keith Packard <keithp@keithp.com> writes:

Keith> On Fri, 2008-08-01 at 16:50 -0400, Christoph Hellwig wrote:
>> Nope.  Let the userspace protion create a file in shmfs instead of
>> adding fugly kernel interfaces hdiing this fact.

Keith> I can't create that many files; I need thousands of them.

Why?  If you need thousands of files, won't the overhead of managing
them dynamically start to be a big load as well?  

I assume (sorry for not looking at the code in depth) that you're
trying to setup specific regions of memory with various attributes for
the DRI/DRM/GEM/TTF access to Video cards?  

Just seeing your statement that you wanted to add ioctls made me
shudder and try to visuallize a better way to do this.  

I realize you're trying to make the drivers generic so that the *BSD
port is simple too, but... thousands of files (per X server?  per
xclient) just seems like the wrong level.

Maybe you just need to open the *entire* card with one FD and then
have your own VFS like abstraction in there, which doesn't require
lots of filehandles?  

Dunno... just trying to figure out what you're try to mediate here
with ioctl() and how it could be improved/simplified.


John

