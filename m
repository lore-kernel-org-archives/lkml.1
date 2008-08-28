Return-Path: <linux-kernel-owner+w=401wt.eu-S1757491AbYH1XTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbYH1XTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 19:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbYH1XT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 19:19:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50992 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbYH1XT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 19:19:28 -0400
Date: Thu, 28 Aug 2008 16:14:26 -0700
From: Greg KH <greg@kroah.com>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Adrian Bunk <bunk@kernel.org>, Tejun Heo <tj@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Miklos Szeredi <miklos@szeredi.hu>, Takashi Iwai <tiwai@suse.de>,
       fuse-devel@lists.sourceforge.net
Subject: Re: [ANNOUNCE] OSS Proxy using CUSE
Message-ID: <20080828231426.GA15284@kroah.com>
References: <48B6F711.1040604@kernel.org> <20080828200120.GA16462@cs181140183.pp.htv.fi> <20080828221828.GB2855@kroah.com> <48B72F53.9080109@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B72F53.9080109@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 04:05:55PM -0700, H. Peter Anvin wrote:
> Greg KH wrote:
>> Independant of that, I can see a number of uses for the CUSE code.  One
>> would be emulating /dev/pilot for old palm pilot software that things it
>> wants to talk to a serial port, yet really a libusb userspace program
>> can handle all of the data to the USB device instead.
>
> I think that's probably another bad example... I would think serial port 
> emulation would be better handled by ptys, and/or a specific serial port 
> emulation module.

Hm, why?  It's a "fake" serial port as it is just a pass-through to the
USB device.  No flow control or line settings work on the device, so the
kernel driver just silently eats them.  But there is old, closed source
software that wants to talk to a serial port, so the kernel driver
remains.  With this code, we could then use the more modern libusb code
instead.

I guess you could hook it up through a pty, and somehow create
/dev/pilot/ for it as well, that is an idea to consider.

> The big problem with using ptys for serial port emulation is that they 
> currently don't handle BREAK at all.

For this type of USB device, that's not an issue :)

thanks,

greg k-h
