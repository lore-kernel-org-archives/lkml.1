Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab0BVW64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 17:58:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754744Ab0BVW6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 17:58:54 -0500
Date: Mon, 22 Feb 2010 14:56:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ari Entlich <atrigent@ccs.neu.edu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2] Add a new VT mode which is like VT_PROCESS but
 doesn't require a VT_RELDISP ioctl call
Message-Id: <20100222145646.27f1f135.akpm@linux-foundation.org>
In-Reply-To: <5702371.144261266590275669.JavaMail.root@zimbra>
References: <33024815.144191266590249679.JavaMail.root@zimbra>
	<5702371.144261266590275669.JavaMail.root@zimbra>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Feb 2010 09:37:55 -0500 (EST) Ari Entlich <atrigent@ccs.neu.edu> wrote:

> This new VT mode (VT_PROCESS_AUTO) does everything that VT_PROCESS does
> except that it doesn't wait for a VT_RELDISP ioctl before switching
> away from a VT with that mode.
> 
> If the X server eventually uses this new mode, debugging and crash
> recovery should become easier. This is because even when currently in
> the VT of a frozen X server it would still be possible to switch out
> by doing SysRq-r and then CTRL-<number of a text vt>, sshing in and
> doing chvt <number of a text vt>, or any other method of VT switching.
> The general concensus on #xorg-devel seems to be that it should be
> safe to use this with X now that we have KMS.

Well, it "should" become easier, but does it?  Has anyone patched their
X server to confirm that this kernel change improves things?  I'm
wondering how this change was tested?

Is there a plan to get the X server modified to use VT_PROCESS_AUTO?

> This also moves the VT_ACKACQ define to a more appropriate place,
> for clarity's sake.
> 

