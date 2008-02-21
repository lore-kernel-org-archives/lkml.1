Return-Path: <linux-kernel-owner+w=401wt.eu-S935469AbYBUWi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935469AbYBUWi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761129AbYBUWik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:38:40 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49128 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759303AbYBUWij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:38:39 -0500
Date: Thu, 21 Feb 2008 22:38:31 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Al Viro <viro@ftp.linux.org.uk>,
       Johannes Berg <johannes@sipsolutions.net>,
       John Linville <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Stefano Brivio <stefano.brivio@polimi.it>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: __bitwise versus __bitwise__ [Was: [PATCH] mac80211: check endianness/types in sparse runs]
Message-ID: <20080221223831.GC27894@ZenIV.linux.org.uk>
References: <1203503909.17534.14.camel@johannes.berg> <20080220195913.GE21139@uranus.ravnborg.org> <1203597776.20331.5.camel@johannes.berg> <1203624091.20345.63.camel@brick> <20080221223239.GA31048@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080221223239.GA31048@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 11:32:39PM +0100, Sam Ravnborg wrote:
> Al - can I ask you to explain the difference between __bitwise
> and __bitwise__ as used by the kernel.

__bitwise__ - to be used for relatively compact stuff (gfp_t, etc.) that
is mostly warning-free and is supposed to stay that way.  Warnings will
be generated without __CHECK_ENDIAN__.

__bitwise - noisy stuff; in particular, __le*/__be* are that.  We really
don't want to drown in noise unless we'd explicitly asked for it.
