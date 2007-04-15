Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbXDOWhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbXDOWhO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 18:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbXDOWhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 18:37:14 -0400
Received: from gateway.crfreenet.org ([81.92.146.254]:48501 "EHLO
	mail.crfreenet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbXDOWhN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 18:37:13 -0400
X-Greylist: delayed 1688 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Apr 2007 18:37:13 EDT
Date: Mon, 16 Apr 2007 00:08:54 +0200
From: Ondrej Zajicek <santiago@crfreenet.org>
To: Anton Vorontsov <cbou@mail.ru>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       dwmw2@infradead.org
Subject: Re: [PATCH 3/7] [RFC] Battery monitoring class
Message-ID: <20070415220854.GA20373@localhost.localdomain>
References: <20070411232503.GC20095@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070411232503.GC20095@zarina>
X-Operating-System: Debian GNU/Linux 3.1 (Sarge)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 03:25:03AM +0400, Anton Vorontsov wrote:
> Here is battery monitor class. According to first copyright string, we're
> maintaining it since 2003. I've took few days and cleaned it up to be
> more suitable for mainline inclusion.

Just some ideas:

- what about using exponents in values?
For example file "voltage" could contain "123 -3" to represent 123 mV.
Exponents could be hardcoded in drivers according to device's range
(so there is no complication in it), but interface is usable in great
range of values. And it is pretty easy to use from userspace.

- interface should allow to present values which are some monotonic
functions of common physical properties. For example when we know
where are some raw data from sensor, but we don't know where are
calibration tables to be able to compute value in some standard unit
(as V for voltage) - in this case it is better to show raw data 
(or raw data after some transformation which makes them monotonic)
and specify that this is raw data than show nothing. 

- it would be nice to know whether presented value is from some
measurement or it is (inaccurate) estimation.

-- 
Elen sila lumenn' omentielvo

Ondrej 'SanTiago' Zajicek (email: santiago@mail.cz, jabber: santiago@njs.netlab.cz)
OpenPGP encrypted e-mails preferred (KeyID 0x11DEADC3, wwwkeys.pgp.net)
"To err is human -- to blame it on a computer is even more so."
