Return-Path: <linux-kernel-owner+w=401wt.eu-S1760970AbXERJrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760970AbXERJrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 05:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbXERJrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 05:47:25 -0400
Received: from zakalwe.fi ([80.83.5.154]:44161 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656AbXERJrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 05:47:25 -0400
Date: Fri, 18 May 2007 12:46:32 +0300
From: Heikki Orsila <shdl@zakalwe.fi>
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: usb-storage nice value
Message-ID: <20070518094632.GF10873@zakalwe.fi>
References: <20070517100308.GA14667@DervishD>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20070517100308.GA14667@DervishD>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 12:03:08PM +0200, DervishD wrote:
>     I'm having problems when reading/writing to external USB harddisks:
> my *internal* harddisk stalls from time to time, so watching a movie
> while copying data is a PITA (well, if the movie is bad, the leaps help
> a bit...).

I've had a similar problem that is caused due to USB write caching. When 
a process rapidly writes to a USB device, the whole memory gets filled 
with write cache. When the memory is full of write cache for USB, it is 
very slow to get clean pages as the USB device is slow. This stalls the 
entire system performance. Using sync mount option for USB solves this 
problem, but decreases write performance significantly.

Would it be possible to limit per device write caching to N pages from 
userspace? Having just 128 MiB of write cache for a USB device would be 
sufficient for high performance, but yet have plenty of clean pages for 
other purposes.

-- 
Heikki Orsila			Barbie's law:
heikki.orsila@iki.fi		"Math is hard, let's go shopping!"
http://www.iki.fi/shd
