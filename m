Return-Path: <linux-kernel-owner+w=401wt.eu-S1760168AbZDABFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168AbZDABFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 21:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbZDABFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 21:05:37 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:58720 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752734AbZDABFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 21:05:37 -0400
Message-ID: <49D2BDE6.7030304@lougher.demon.co.uk>
Date: Wed, 01 Apr 2009 02:05:42 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Stephen Hemminger <shemminger@vyatta.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
       squashfs-devel@lists.sourceforge.net
Subject: Re: Squashfs 4.0 tools
References: <20090323180808.2c2ef1a7@nehalam> <10f740e80903290202h1f36b370ga39721536d52a90@mail.gmail.com> <20090330175524.4e8f802e@nehalam> <200903311431.20494.rob@landley.net>
In-Reply-To: <200903311431.20494.rob@landley.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> On Monday 30 March 2009 19:55:24 Stephen Hemminger wrote:
>> I built it from cvs (imported into git), and it works okay.
> 
> I grabbed the cvs snapshot gentoo's been using, but I don't see any way to 
> feed in a device list text file so I can create the /dev/console node root 
> filesystems need without needing root access on the host to mknod.
> 
> genext2fs has the -D option, which takes:
> 
>   /dev d 755 0 0 - - - - -
>   /dev/console c 640 0 0 5 1 0 0 -
> 
> gen_init_cpio takes:
> 
>   dir /dev 755 0 0
>   nod /dev/console 660 0 0 c 5 1
> 
> Is there a squashfs option I'm missing...?
> 

No you're unfortunately not missing an option :-)  That option
doesn't exist.

But thanks for sending the email, a couple of people over the
years have asked for something like this, and you've reminded
me that this option doesn't exist in Mksquashfs...

I have thought about adding this option a couple of times, but
it has always been dropped through lack of time.  Efficiently
adding the option isn't as easy as it sounds because the "fake"
device nodes have to somehow be made available to the
recursive directory scan routine that scans the source
directories for files.  Adding a list of fake device
nodes which is scanned on every directory for potential inclusion
in that directory is easy, but not terribly efficient.

I'll delay the release of the 4.0 tools and see if I can
implement this option in the next day or two.

Phillip

