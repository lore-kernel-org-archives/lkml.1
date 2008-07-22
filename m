Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbYGVSbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbYGVSbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 14:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYGVSbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 14:31:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44407 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbYGVSbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 14:31:18 -0400
Subject: Re: Firmware breakage
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org
In-Reply-To: <20080722190516.4ee477f4@lxorguk.ukuu.org.uk>
References: <20080722173420.6f90556d@lxorguk.ukuu.org.uk>
	 <1216748431.3019.6.camel@shinybook.infradead.org>
	 <20080722190516.4ee477f4@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Tue, 22 Jul 2008 14:31:04 -0400
Message-Id: <1216751464.3019.29.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-22 at 19:05 +0100, Alan Cox wrote:
> On Tue, 22 Jul 2008 13:40:31 -0400
> David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > On Tue, 2008-07-22 at 17:34 +0100, Alan Cox wrote:
> > > If you crossbuild x86-32 on x86-64 and then attempt to do the install on
> > > an x86-32 box the install now breaks. This used to work until the
> > > firmware changes. Now you get
> > > 
> > > /bin/sh: scripts/basic/fixdep: cannot execute binary file
> > > 
> > > Fixdep should be built for the target platform surely ?
> > 
> > Er, I haven't knowingly touched anything involving fixdep. Can you show
> > me exactly what you did? I'll try to reproduce and understand what's
> > happening.
> 
> Build on a 64bit box with ARCH=i386
> NFS mount on a 32bit box
> make modules_install on 32bit box
> 
> It used to work nicely, as of the firmware changes it doesn't. Not sure
> what the trigger is here yet.

Hm, I think it's because we're not building the firmware binaries until
modules_install time, and only _then_ do we want to build the ihex2fw
tool.

If you run 'make modules_install INSTALL_MOD_PATH=/tmp/foo' on the
x86_64 host first, does that fix it?

I was planning to build the firmware binaries as part of 'make modules'
anyway, because Rafael had related problems (not being able to write to
the NFS-exported kernel tree at all).

-- 
dwmw2

