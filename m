Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbXKAOdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbXKAOdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 10:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636AbXKAOc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 10:32:56 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4264 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754573AbXKAOcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 10:32:55 -0400
Date: Mon, 29 Oct 2007 19:08:13 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Mike Waychison <mikew@google.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/1] Drop CAP_SYS_RAWIO requirement for FIBMAP
Message-ID: <20071029190813.GB7742@ucw.cz>
References: <20071025230758.945535769@crlf.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071025230758.945535769@crlf.corp.google.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Remove the need for having CAP_SYS_RAWIO when doing a FIBMAP call on an open file descriptor.
> 
> It would be nice to allow users to have permission to see where their data is landing on disk, and there really isn't a good reason to keep them from getting at this information.

I believe it is to prevent users from intentionally creating extremely
fragmented files...

You can read 60MB in a second, but fragmented 60MB file could take
10msec * 60MB/4KB = 150 seconds. That's factor 150 slowdown...

...but I agree that SYS_RAWIO may be wrong capability to cover this.

							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
