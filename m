Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbXLIV1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbXLIV1o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 16:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbXLIV1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 16:27:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43997 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbXLIV1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 16:27:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: bbpetkov@yahoo.de
Subject: Re: [RFC] swap image signature check upon resume
Date: Sun, 9 Dec 2007 22:46:35 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
References: <20071206211335.GA4923@gollum.tnic> <200712091527.57523.rjw@sisk.pl> <20071209160959.GA4978@gollum.tnic>
In-Reply-To: <20071209160959.GA4978@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712092246.36217.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 9 of December 2007, Borislav Petkov wrote:
> On Sun, Dec 09, 2007 at 03:27:57PM +0100, Rafael J. Wysocki wrote:
> ...
> 
> > > Instead, I'd rather issue a warning that the swsusp header mismatches, say with
> > > which kernel the machine got suspended with and then start the countdown for reboot.
> > 
> > What exactly would that change?  You need to reboot anyway and fsck will run on
> > the filesystems regardless of which kernel you boot with.
> 
> well, you'll have the chance to reboot with the kernel the machine got suspended
> with and then the swsusp image header _will_ match so no fsck-ing. or am i
> missing something...

Yes, you are. :-)

With the new code (which BTW I'm assuming we are talking about) the images are
not matched against the kernel they were created by, but against a hard-coded
magic number (defined in suspend_64.c) playing the role of the "header protocol
version" and against some system parameters, like the amount of RAM etc.
Since all kernels containing the new code use the same magic number, all of
them will match or none of them will match.

Of course, we may want to change the magic at some point and in that case
there you will have some non-matching kernels.  If you're worried about that,
use the userland hibernation tools from suspend.sf.net (they handle such
situations quite well).

Greetings,
Rafael
