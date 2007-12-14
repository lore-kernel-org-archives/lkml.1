Return-Path: <linux-kernel-owner+w=401wt.eu-S1765542AbXLNKvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765542AbXLNKvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 05:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759994AbXLNKve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 05:51:34 -0500
Received: from ns1.suse.de ([195.135.220.2]:46761 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756636AbXLNKvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 05:51:33 -0500
To: "David P. Reed" <dpreed@reed.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80 on some AMD64x2 laptops, etc.
From: Andi Kleen <andi@firstfloor.org>
References: <466F0941.9060201@reed.com> <1181682498.8176.224.camel@chaos>
	<469578CD.3080609@reed.com> <1184216528.12353.203.camel@chaos>
	<1184218962.12353.209.camel@chaos> <46964352.7040301@reed.com>
	<1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com>
	<1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com>
Date: Fri, 14 Dec 2007 11:51:24 +0100
In-Reply-To: <4761F193.7090400@reed.com> (David P. Reed's message of "Thu\, 13 Dec 2007 21\:59\:31 -0500")
Message-ID: <p73prx9ft1v.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"David P. Reed" <dpreed@reed.com> writes:
>
> i386 family fixes (completely parallel) were not included, considering
> that such machines might involve more risk of problems on legacy machines.

They're needed because lots of people fomr some reason still boot 32bit kernels
on 64bit machines.
> +#define __OUT(s, s1, x) \

> +__OUT1(s, x) __OUT2(s, s1, "w") } \
> + __OUT1(s##_p, x) __OUT2(s, s1, "w") udelay(_IOPORT_PAUSE_DELAY); } \

With the additional call this should be completely out of line now to save 
code size. Similar for the in variant.

-Andi

