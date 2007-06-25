Return-Path: <linux-kernel-owner+w=401wt.eu-S1755272AbXFYNhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbXFYNhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 09:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbXFYNhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 09:37:04 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2238 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbXFYNhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 09:37:01 -0400
Date: Mon, 25 Jun 2007 15:37:03 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] cross-architecture ELF clean up
In-Reply-To: <20070620230902.387008536@goop.org>
Message-ID: <Pine.LNX.4.64.0706251531110.4386@scrub.home>
References: <20070620230854.246399397@goop.org> <20070620230902.387008536@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 20 Jun 2007, Jeremy Fitzhardinge wrote:

> This patch cleans up the ELF headers and their users.  It does several
> related things:
> 
> 1. split linux/elf.h into pieces
> 
> This splits linux/elf.h into several pieces:
> 	linux/elf.h		- still the common elf header,
> 				  functionally unchanged
> 	linux/elf-const.h	- ELF constants, includable by asm code

We have the __ASSEMBLY__ define for this, so just for asm code we don't 
need a separate header.

> 	linux/elf-decl.h	- ELF type declarations, without definitions
> 	linux/elf-defn.h	- ELF type definitions

What's the point in splitting these two?

After this patch <linux/elf.h> seems to be pretty much empty, I'd rather 
suggest to move the function declarations to elfcore.h and leave the basic 
elf definitions in elf.h. Many small header files have the disadvantage 
that it takes longer to find the needed information.

bye, Roman
