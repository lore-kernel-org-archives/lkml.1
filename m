Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbYA2FsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbYA2FsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 00:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYA2FsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 00:48:01 -0500
Received: from [216.123.194.198] ([216.123.194.198]:34813 "EHLO
	mail.harddata.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbYA2FsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 00:48:00 -0500
X-Greylist: delayed 3540 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jan 2008 00:47:59 EST
Date: Mon, 28 Jan 2008 21:48:23 -0700
From: Michal Jaegermann <michal@harddata.com>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Daniel Barkalow <barkalow@iabervon.org>,
       Richard Heck <rgheck@bobjweil.com>, Zan Lynx <zlynx@acm.org>,
       Calvin Walton <calvin.walton@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux ide Mailing list <linux-ide@vger.kernel.org>
Subject: Re: Problem with ata layer in 2.6.24
Message-ID: <20080129044823.GA12553@mail.harddata.com>
References: <200801272122.21823.gene.heskett@gmail.com> <200801281905.35278.gene.heskett@gmail.com> <alpine.LNX.1.00.0801281909170.13593@iabervon.org> <200801282031.58429.gene.heskett@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801282031.58429.gene.heskett@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 08:31:57PM -0500, Gene Heskett wrote:
> 
> In my script, its one line:
> mkinitrd -f initrd-$VER.img $VER && \
> 
> where $VER is the shell variable I edit to = the version number, located at 
> the top of the script.
> 
> Unforch, its failing:
> No module pata_amd found for kernel 2.6.24, aborting.

mkinitrd is just a shell script.  Even if its options, and there is
a quite a number of these, do not allow to influence a choice of
modules in a desired manner, it is pretty trivial to make yourself a
custom version of it and just hardwire there a fixed list of modules
to use instead of relying on general mechanisms which are trying
hard to guess what you may need.

That way your regular 'mkinitrd' will build something to boot with
libata and 'mkinird.ide' will use IDE modules for that purpose using
the same "core" kernel.

If you are using distribution kernels, as opposed to your own
configuration, it is quite likely that you will need to install
'kernel-devel' package and recompile and add required IDE modules
yourself as those may be not provided.  This is done the same way
like for any other "external" module.

   Michal
