Return-Path: <linux-kernel-owner+w=401wt.eu-S932803AbXA1UXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803AbXA1UXs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 15:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932815AbXA1UXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 15:23:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932803AbXA1UXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 15:23:47 -0500
Date: Sun, 28 Jan 2007 15:23:37 -0500
From: Dave Jones <davej@redhat.com>
To: jmoyer@redhat.com
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Fernandez <sfernand@redhat.com>, Andrew Morton <akpm@osdl.org>
Subject: Re: [patch] raw: don't allow the creation of a raw device with minor number 0
Message-ID: <20070128202336.GA23903@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, jmoyer@redhat.com,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Steven Fernandez <sfernand@redhat.com>,
	Andrew Morton <akpm@osdl.org>
References: <x49bql48aus.fsf@segfault.boston.devel.redhat.com> <Pine.LNX.4.61.0701122341030.19224@yvahk01.tjqt.qr> <m38xg73l9a.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m38xg73l9a.fsf@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 12, 2007 at 05:58:41PM -0500, jmoyer@redhat.com wrote:
 > ==> Regarding Re: [patch] raw: don't allow the creation of a raw device with minor number 0; Jan Engelhardt <jengelh@linux01.gwdg.de> adds:
 > 
 > jengelh> On Jan 12 2007 11:32, Jeff Moyer wrote:
 > 
 > >> Minor number 0 (under the raw major) is reserved for the rawctl device
 > >> file, which is used to query, set, and unset raw device bindings.
 > >> However, the ioctl interface does not protect the user from specifying
 > >> a raw device with minor number 0:
 > 
 > jengelh> No idea what to say about this... probably:
 > 
 > jengelh>   What:   RAW driver (CONFIG_RAW_DRIVER)
 > jengelh>   When:   December 2005
 > jengelh>   Why:    declared obsolete since kernel 2.6.3
 > jengelh>           O_DIRECT can be used instead
 > jengelh>   Who:    Adrian Bunk <bunk@stusta.de>
 > 
 > It's still present, still used, and so would benefit from being fixed, in
 > my opinion.

Given the tirade against O_DIRECT on linux-kernel earlier this month,
it has me wondering about the validity of this entry.

Every time we've tried to deprecate this driver in Fedora/RHEL, we've
had enough people complain that we've ended up having to turn it back on.
(And I'm fairly sure other distros have been in the same position).
Some vendors seem way too attached to the older semantics than having
to rewrite their apps to use O_DIRECT, and unnecessarily breaking them
so that we can throw away a 306 line driver in the name of cleanliness
seems a bit gratuitous.

		Dave

-- 
http://www.codemonkey.org.uk
