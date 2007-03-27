Return-Path: <linux-kernel-owner+w=401wt.eu-S932424AbXC0P45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424AbXC0P45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 11:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932456AbXC0P45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 11:56:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37715 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932424AbXC0P44 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 11:56:56 -0400
To: =?iso-8859-2?q?Pawe=B3_Sikora?= <pluto@agmk.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: smart gcc inliner...
References: <46093349.7060401@agmk.net>
From: Andi Kleen <andi@firstfloor.org>
Date: 27 Mar 2007 18:55:36 +0200
In-Reply-To: <46093349.7060401@agmk.net>
Message-ID: <p73ircm4odz.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pawe³ Sikora <pluto@agmk.net> writes:

> Hi,
> 
> The recent gcc (3.4/4.x) optimizer inlines functions across
> sections which is definitely not we want, e.g. inlining
> functions from .init.text section.
> 
> I think, the `__init' macro needs `noinline' attribute and all
> the `static inline __{dev}init' functions need `inline' attribute
> removal to avoid gcc error (inlining failed, function not inlinable).
> 


init functions should only ever be called from other init functions.

So this should not happen. If it happens the annotations need to be fixed.

This is already warned for for modules at build time with pending
patches to do the same for vmlinux.

There are already a couple of patches pending for this and many 
went into .21.

-Andi
