Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbYLOLab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbYLOLab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 06:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbYLOLaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 06:30:22 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:37038 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbYLOLaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 06:30:21 -0500
Date: Mon, 15 Dec 2008 12:31:50 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: make headers_install: .install and ..install.cmd
Message-ID: <20081215113150.GA10911@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0812141728370.5714@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812141728370.5714@anakin>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2008 at 05:31:08PM +0100, Geert Uytterhoeven wrote:
> 	Hi Sam,
> 
> When I use `make ARCH=m68k INSTALL_HDR_PATH=/tmp/headers headers_install',
> I get lots of `.install' and `..install.cmd' files in /tmp/headers and its
> subdirectories.
> 
> I'm building the kernel in a separate output directory and run my make command
> from there.
> 
> Is this intentional?

Hi Geert.

We use the files .install and ..install.cmd to check if we need to install
the headers again or need to check them again.
And there is no other place to put them than next to the relevant files.
Otherwse we would not do the right thing when exporting to
two different directories from the same repository.

The real fix would be to speed up the install step.
Today we rely on the unifdef tool and a perl scrip for the installation.
Combining the functionality in one C file would most likely
speed up the install process to such a degree that we can do it
unconditionally and then we can get rid of the .install 
and ..install.cmd files.

But noone has written a C program to do that (yet).

	Sam
