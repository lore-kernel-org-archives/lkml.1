Return-Path: <linux-kernel-owner+w=401wt.eu-S1755599AbXKWBtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbXKWBtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 20:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbXKWBtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 20:49:45 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:56192 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbXKWBtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 20:49:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gLmosx44jpX5EAEjkyiQdk/YyzrGL9ZIU7VVo1t6wpvjViVNwcVbcj9R838RlPCmcdc3yNxpPXO02Q9tlvIuK2QAxyzWfG2/uihCMXGIJ5yuHicuuvbJ0nI0FvsHHjqRHJyIBkX4t/kI9rB6lb3+0n+srf6DGg/HimEjQ9uporI=
Message-ID: <118833cc0711221749h2da36d7ek856ee91cdeda955@mail.gmail.com>
Date: Thu, 22 Nov 2007 20:49:43 -0500
From: "Morten Welinder" <mwelinder@gmail.com>
To: "Jan Kara" <jack@suse.cz>
Subject: Re: Inotify fails to send IN_ATTRIB events
Cc: linux-kernel <linux-kernel@vger.kernel.org>, rlove@rlove.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20071122153446.GA6299@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <118833cc0711201911r3684937p38823649639e0a57@mail.gmail.com>
	 <20071122153446.GA6299@atrey.karlin.mff.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Wanna try the patch below?

With this patch I am seeing a endless stream of  IN_IGNORED events
for a removed watch.  I don't see a reason that user space should
ever see any IN_IGNORED, but an endless steam is not good.

Utterly unrelated, inotify does not work in /proc/.  The list archives
suggest that it isn't likely to start working anytime soon, but shouldn't
inotify_add_watch when fail with ENOSYS instead of pretending
it worked?

Morten




Failed to create inotify watch for /home/welinder/hi: No such file or directory
Created inotify watch 1 with mask 0x000007c0 for /home/welinder
# "touch hi" here
Got event 00000100 for 1
Created inotify watch 2 with mask 0x00000fc6 for /home/welinder/hi
Removing notify watch 1
Got event 00008000 for 1
Got event 00000004 for 2
# "rm hi" here
Got event 00000400 for 2
Removing notify watch 2
Got event 00008000 for 2
Failed to create inotify watch for /home/welinder/hi: No such file or directory
Created inotify watch 3 with mask 0x000007c0 for /home/welinder
Got event 00000200 for 3
Failed to create inotify watch for /home/welinder/hi: No such file or directory
Created inotify watch 3 with mask 0x000007c0 for /home/welinder
# "touch hi" here
Got event 00000100 for 3
Created inotify watch 4 with mask 0x00000fc6 for /home/welinder/hi
Removing notify watch 3
Got event 00008000 for 3
Got event 00000004 for 4
Got event 00000004 for 4
# "rm hi" here
Got event 00000400 for 4
Removing notify watch 4
Failed to create inotify watch for /home/welinder/hi: No such file or directory
Created inotify watch 5 with mask 0x000007c0 for /home/welinder
Got event 00008000 for 4
Got event 00008000 for 4
Got event 00008000 for 4
Got event 00008000 for 4
...
