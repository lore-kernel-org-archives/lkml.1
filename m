Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbYE0GZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbYE0GZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 02:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbYE0GY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 02:24:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36208 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340AbYE0GYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 02:24:55 -0400
Subject: Re: Linux 2.6.26-rc4
From: David Woodhouse <dwmw2@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
In-Reply-To: <20080526230022.682688e9@infradead.org>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>
	 <483B2A9B.4050007@krogh.cc>
	 <alpine.LFD.1.10.0805261428140.2958@woody.linux-foundation.org>
	 <20080526172519.10d944ab@infradead.org>
	 <1211867031.10205.13.camel@shinybook.infradead.org>
	 <20080526230022.682688e9@infradead.org>
Content-Type: text/plain
Date: Tue, 27 May 2008 07:24:22 +0100
Message-Id: <1211869462.10205.19.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-26 at 23:00 -0700, Arjan van de Ven wrote:
> > The driver needs that 'more' to reach the lock registers for the flash
> > chip. If it's being used for other things, shouldn't the
> > request_region() fail?
> 
> it does fail....
> ... and then the driver continues anyway!

Heh. That's.... naughty. There are kind of valid reasons for that kind
of thing occasionally, but I suspect not this time.

> absolutely
> 
> do we need a MODULE_NO_AUTOLOAD() ?

Just dropping the MODULE_DEVICE_TABLE() should suffice. We should
probably also use the code which is currently in #if 0 which uses
pci_register_driver() instead of doing things for itself; I'm not
entirely sure why that is commented out.

-- 
dwmw2

