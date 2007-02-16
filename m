Return-Path: <linux-kernel-owner+w=401wt.eu-S1946125AbXBPUWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946125AbXBPUWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 15:22:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946123AbXBPUWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 15:22:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946121AbXBPUV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 15:21:59 -0500
Date: Fri, 16 Feb 2007 15:21:35 -0500
From: Dave Jones <davej@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: David Howells <dhowells@redhat.com>, torvalds@osdl.org, akpm@osdl.org,
       herbert.xu@redhat.com, linux-kernel@vger.kernel.org,
       arjan@infradead.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
Message-ID: <20070216202135.GA22121@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Pavel Machek <pavel@ucw.cz>, David Howells <dhowells@redhat.com>,
	torvalds@osdl.org, akpm@osdl.org, herbert.xu@redhat.com,
	linux-kernel@vger.kernel.org, arjan@infradead.org,
	linux-crypto@vger.kernel.org
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com> <20070215221304.GB6602@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070215221304.GB6602@ucw.cz>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 10:13:04PM +0000, Pavel Machek wrote:
 > Hi!
 > 
 > > Now, this is not a complete solution by any means: the core kernel is not
 > > protected, and nor are /dev/mem or /dev/kmem, but it denies (or at least
 > > controls) one relatively simple attack vector.
 > 
 > Could we fix the /dev/*mem holes, first? They are already used by
 > malicious modules (aka rootkits...).  Or can selinux already provide
 > /dev/*mem protection with no way for admin to turn it off?

There are some valid uses for peeking through /dev/mem. Things like
dmidecode for example.  So you don't want to disable it completely
in a lot of cases, but have fine-grained access to specific parts
of the file.  I'm not sure SELinux can do this. Maybe the MLS stuff
helps here (though I'm far from an expert on this, so I could be
talking out of my rear).

The restricted dev/mem patches we've had in Fedora for a while
do the right thing, but they're a bit crufty (in part due to
drivers/char/mem.c being a bit of a mess before we even start
patching it).  I've had "clean these up for upstream" on my
todo for a while. I might get around to it one of these days.

		Dave

-- 
http://www.codemonkey.org.uk
