Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbXJAW4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbXJAW4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 18:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbXJAWz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 18:55:57 -0400
Received: from mx1.suse.de ([195.135.220.2]:44788 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbXJAWz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 18:55:57 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [RFC] Extending kbuild syntax
Date: Tue, 2 Oct 2007 00:57:07 +0200
User-Agent: KMail/1.9.5
Cc: kbuild devel <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
References: <20070929201145.GA20377@uranus.ravnborg.org>
In-Reply-To: <20070929201145.GA20377@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710020057.07322.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 September 2007 22:11, Sam Ravnborg wrote:
> The second is the more controversial suggestion.
> In several Makefile we have simple if expression of the variants:
> if ($(CONFIG_FOO),y)
>   obj-$(CONFIG_BAR) += fubar.o
> endif

Sometimes substitution looks acceptable:

> -nfsd-$(CONFIG_NFSD)		:= nfsctl.o
> -obj-y				+= $(nfsd-y) $(nfsd-m)
> +obj-y-if-$(CONFIG_NFSD)		+= nfsctl.o

obj-$(CONFIG_NFSD:m=y) += nfsctl.o


But for the nontrivial cases, things get pretty ugly:

> -ifeq ($(CONFIG_PROC_FS),y)
> -obj-$(CONFIG_LOCKDEP) += lockdep_proc.o
> -endif

obj-$(CONFIG_PROC_FS:y=$(CONFIG_LOCKDEP)) += lockdep_proc.o

Andreas
