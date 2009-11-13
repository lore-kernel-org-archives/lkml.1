Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbZKMQ4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbZKMQ4B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 11:56:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754852AbZKMQz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 11:55:57 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43899 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753924AbZKMQz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 11:55:56 -0500
Date: Fri, 13 Nov 2009 16:57:30 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Pavel Machek <pavel@ucw.cz>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, Matteo Croce <technoboy85@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091113165730.0b9b2676@lxorguk.ukuu.org.uk>
In-Reply-To: <20091113162301.GU15157@caffeine.csclub.uwaterloo.ca>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com>
	<20091003072127.GC21407@elte.hu>
	<40101cc30911060659k7b3b6428ob1340e476bdbac5b@mail.gmail.com>
	<4AF4526B.4060101@zytor.com>
	<40101cc30911081042n93e268bs66b9436a0174a19a@mail.gmail.com>
	<20091109201608.GD15159@caffeine.csclub.uwaterloo.ca>
	<4AF886D4.1080108@zytor.com>
	<20091109212333.GE15159@caffeine.csclub.uwaterloo.ca>
	<20091112121805.GF1394@ucw.cz>
	<20091113162301.GU15157@caffeine.csclub.uwaterloo.ca>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> Calling memcpy_toio on the Geode SC1200 on anything larger than 1 byte
> causes the data to be delivered (at least on the PCI bus) reordered in
> that very consistent manner.

Sounds like you or your firmware have the caching and write combining
misconfigured.

> 
> The alignment doesn't affect it (I tested that).  Simply doing more than
> 1 byte at a time with memcpy_toio to the pci device messes up.

Which usually means some form of write gathering is enabled or something
thinks the device is write combining on the PCI bus. What does the PCI
bus and the RCRR MTRR set look like ?

