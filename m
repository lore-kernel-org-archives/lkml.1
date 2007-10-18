Return-Path: <linux-kernel-owner+w=401wt.eu-S1763120AbXJRLpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763120AbXJRLpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 07:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755494AbXJRLo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 07:44:58 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:47104 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755234AbXJRLo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 07:44:57 -0400
Date: Thu, 18 Oct 2007 13:46:26 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Linux Kernel Mailing list <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       kbuild-devel@lists.sourceforge.net
Subject: Re: [patch] modpost problem when symbols move from one module to another
Message-ID: <20071018114626.GA19539@uranus.ravnborg.org>
References: <Pine.LNX.4.58.0710111631350.13556@shell4.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0710111631350.13556@shell4.speakeasy.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 04:40:10PM -0700, Trent Piepho wrote:
> The v4l-dvb tree recently renamed a module and this caused some problems
> with modpost creating incorrect module dependencies.  This patch fixes that
> problem.  It should be explained thoroughly in the patch description.
> modpost: Fix problem with out of date Module.symvers
> 
> When part of build an external module tree, modpost first reads in the
> kernel's and then the external tree's Module.symvers files.  From these files
> it establishes a symbol => module mapping.  When it later reads in each module
> built and processes the symbols it finds, it discovers the symbol=>module
> mapping from Module.symvers and leaves it as it is.
> 
> The problem comes with a module has been re-named or a symbol has moved from
> one module to another, since the Module.symvers file was generated.  modpost
> does not update the symbol=>module mapping when it finds the new location of
> the symbol when scanning the newly built modules.  This results in the module
> containing incorrect dependency information and the new Module.symvers file
> written by modpost will also contain the incorrect mappings, perpetuating the
> problem to the next build, and so on.
> 
> When building the out of kernel development tree for kernel subsystem, like
> v4l-dvb or ALSA, deleting the external Module.symvers file before building
> (which the kernel build system doesn't do and shouldn't be necessary anyway),
> won't fix the problem.  modpost still reads the kernel's Module.symvers, and
> since we a building a kernel subsystem, it will define the same symbols as the
> external modules.
> 
> Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>

Thanks - applied,

	Sam
