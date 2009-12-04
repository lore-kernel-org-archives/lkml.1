Return-Path: <linux-kernel-owner+w=401wt.eu-S932388AbZLDRrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbZLDRrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 12:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932300AbZLDRrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 12:47:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932265AbZLDRrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 12:47:15 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1244854869-2563-1-git-send-email-vapier@gentoo.org>
References: <1244854869-2563-1-git-send-email-vapier@gentoo.org>
To: uClinux development list <uclinux-dev@uclinux.org>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       Jie Zhang <jie.zhang@analog.com>, Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       David McCullough <davidm@snapgear.com>
Subject: Re: [uClinux-dev] [PATCH/RFC] FDPIC: add hook for arches to customize program header parsing
Date: Fri, 04 Dec 2009 17:44:57 +0000
Message-ID: <14959.1259948697@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier@gentoo.org> wrote:

> The Blackfin port has custom program header flags/addresses for
> automatically loading regions into the dedicated on-chip SRAM.  So add a
> hook for ports to leverage.

Now that I've ACK'd this, I feel I'm going to have to NAK it.  I'm not against
the general concept, but:

> +		do_munmap(mm, *maddr, phdr->p_memsz + *disp);

There needs to be a mapping covering the SRAM region for the purposes of the
debugger.  Do you have a chardev covering the SRAM device?  Perhaps through
MTD?

David
