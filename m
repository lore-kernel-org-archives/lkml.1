Return-Path: <linux-kernel-owner+w=401wt.eu-S1765628AbYAaIzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765628AbYAaIzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 03:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYAaIy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 03:54:58 -0500
Received: from pip15.gyao.ne.jp ([61.122.117.253]:27927 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751934AbYAaIy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 03:54:57 -0500
Date: Thu, 31 Jan 2008 17:54:08 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Francis Moreau <francis.moro@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [Kbuild] How to clean a particular directory ?
Message-ID: <20080131085408.GA14470@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Francis Moreau <francis.moro@gmail.com>,
	linux-kernel@vger.kernel.org
References: <38b2ab8a0801310038o2906ab68ta8893240576d806d@mail.gmail.com> <20080131084851.GB14160@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131084851.GB14160@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 05:48:51PM +0900, Paul Mundt wrote:
> On Thu, Jan 31, 2008 at 09:38:10AM +0100, Francis Moreau wrote:
> > I'd like to clean a particular directory in the kernel tree.
> > 
> > I tried several things such as:
> > 
> > $ make drivers/char clean
> > $ make -f scripts/Makefile.clean obj=drivers/char
> > 
> > But it doesn't work.
> > 
> > Could anybody give me  a hint ?
> 
> make SUBDIRS=drivers/char clean
> 
> should do the trick. Kbuild might have a magic incantation for it these
> days, but that's the way it used to work, and still seems to.

Makefile says:

# Use make M=dir to specify directory of external module to build
# Old syntax make ... SUBDIRS=$PWD is still supported
# Setting the environment variable KBUILD_EXTMOD take precedence
ifdef SUBDIRS
  KBUILD_EXTMOD ?= $(SUBDIRS)
endif
ifdef M
  ifeq ("$(origin M)", "command line")
    KBUILD_EXTMOD := $(M)
  endif
endif

so M= is apparently the newfangled (and undocumented) way of doing this.
