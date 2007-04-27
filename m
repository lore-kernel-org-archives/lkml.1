Return-Path: <linux-kernel-owner+w=401wt.eu-S1757896AbXD0XY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896AbXD0XY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 19:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757897AbXD0XY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 19:24:26 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:33003 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757896AbXD0XYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 19:24:25 -0400
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=booyaka.com;
  b=amxHJ/P/P/kniy3SUZHDxRCYtM4AZnEsOQfKsFdEfAlNqkJgZyiXWDLl+UvY+X04JI5JjQvLJxtNyrF2w7cno0v5jZN7Zx4mNedtjQr2R21jPpr4xh/pDPtVepYDiZNd7ELX96vKI1/igdhW0TvtmDiHbWzhGnDHXdsoLmfWcf5d+OxaGpoPCptvE5RYbfHm7X1i2cli1p06rNSZoDuUwyQ35Aq4MbZVHluqD/Gathk2Lmb/nlsksnGV9lqTIXNvYmMCch5RDWTvi2W7QozG3Zx63DutB7yfwNX3dTZ4ZWK97F0PBUPk9GX43khDp7gE+W2ETqkLmJ+A34tLeEKhuQ==  ;
Date: Fri, 27 Apr 2007 17:24:24 -0600 (MDT)
From: Paul Walmsley <paul@booyaka.com>
To: Jiri Kosina <jkosina@suse.cz>
cc: Greg KH <greg@kroah.com>, "VE \(HOME\)" <ve@vetienne.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, fubar@us.ibm.com
Subject: Re: USB HID bug (was [PROBLEM] Bonding driver in linux-2.6.21-rc6-mm1)
In-Reply-To: <Pine.LNX.4.64.0704280024170.7370@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0704271651260.21519@utopia.booyaka.com>
References: <200704262058.33087.ve@vetienne.net> <20070426211146.f370cf81.akpm@linux-foundation.org>
 <010a01c788ae$0a7d0140$5601a8c0@apws2> <20070427211836.GC5917@kroah.com>
 <Pine.LNX.4.64.0704280024170.7370@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Sat, 28 Apr 2007, Jiri Kosina wrote:

> Paul, do you have any idea? In fact, what was your reason for putting this
> WARN_ON() there?

The static quirk list uses idVendor == 0 to mark the end of 
hid_blacklist[], so we don't expect any device to have idVendor == 0.  If 
a device is correctly presenting with idVendor == 0, we need a different 
way to terminate that blacklist.  Either that or there's an upper-layer 
bug, as you write.

Regarding its placement: that WARN_ON() belongs in the static quirk lookup 
code, rather than where it is now.  Its current location must be a relic 
of an earlier patchset.

> Did you ever meet any condition when idVendor == 0 appears there?

No.  There shouldn't be any functional problem with removing that 
WARN_ON(), and also removing the initial if() in usbhid_lookup_dquirk().


- Paul
