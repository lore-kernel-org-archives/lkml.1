Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab0BMRK1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 12:10:27 -0500
Received: from bamako.nerim.net ([62.4.17.28]:61278 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757435Ab0BMRKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 12:10:12 -0500
Date: Sat, 13 Feb 2010 18:10:08 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "J.H." <warthog9@kernel.org>, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       users@kernel.org, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100213181008.479509f5@hyperion.delvare>
In-Reply-To: <20100211205129.GA26105@elf.ucw.cz>
References: <4B744E13.8040004@kernel.org>
	<20100211205129.GA26105@elf.ucw.cz>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel, all,

On Thu, 11 Feb 2010 21:51:29 +0100, Pavel Machek wrote:
> Hi!
> 
> > Option 1)
> > 
> > Leave gz as the master, and migrate bz2 to xz.  This will happen in
> > stages obviously. with bz2 ultimately being phased out.
> > 
> > 	Migration option 1)
> > 
> > 		All new content would be provided in .bz2 and .xz with
> > 		an ultimate date set that the .bz2 files would stop
> > 		being generated with new content.  This would leave all
> > 		existing content alone and it would not be a migration
> > 		of the current .bz2 files to xz
> 
> I believe this is cleanest. gzip has performance advantages, (...)

I have been investigating this issue and would like to share my
findings as an additional data point for this discussion.

For my testing, I have been using the slowest machine I still have
available here: a Pentium 166 MMX, with 64 MB of memory and a slow hard
disk drive. I've been writing down the duration of each task it took to
boot kernel 2.6.27.45 on this machine. I did this for both .gz and .bz2
formats.

Raw results are as follow (format=min:s):

downloading linux-2.6.27.tar.bz2	  5:01
downloading patch-2.6.27.45.bz2		  0:02
unpacking linux-2.6.27.tar.bz2		  7:28
applying patch-2.6.27.45.bz2		  1:21
----------------------------------------------
total for bz2				 13:52

downloading linux-2.6.27.tar.gz		  6:23
downloading patch-2.6.27.45.gz		  0:02
unpacking linux-2.6.27.tar.gz		  3:20
applying patch-2.6.27.45.gz		  1:10
----------------------------------------------
total for gz				 10:55

So the gz option is unsurprisingly faster, setting up the source tree
takes almost 3 minutes less (-21%).

Then the (common) build and installation times:

building				117:26
installing modules			  0:12
----------------------------------------------
total					117:38

This is a customized kernel, as small as I could do, with almost no
features and the minimal set of drivers. As you can see, the build time
is one order of magnitude greater than the tree setup time. Comparing
the total times from download to install between bz2 and gz:

bz2: 13:52 + 117:38 = 131:30
gz:  10:55 + 117:38 = 128:33

Compared to bz2, gz saves... 2% on the overall time. As a conclusion, I
think we can plain discard the argument "I need .gz because my machine
is slow" from now on. It simply doesn't hold.

-- 
Jean Delvare
