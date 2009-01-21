Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbZAUUGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbZAUUGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 15:06:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbZAUUGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 15:06:33 -0500
Received: from www.tglx.de ([62.245.132.106]:53569 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbZAUUGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 15:06:33 -0500
Date: Wed, 21 Jan 2009 21:06:12 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Brandon Philips <brandon@ifup.org>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: uio: add the uio_aec driver
Message-ID: <20090121200612.GA9626@local>
References: <20090120204729.GA26477@jenkins.ifup.org> <20090120214832.GE3027@local> <20090121170116.GA18567@jenkins.ifup.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090121170116.GA18567@jenkins.ifup.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 09:01:16AM -0800, Brandon Philips wrote:
> > The portio feature is available since .29-rc1, please use it.
> 
> Sounds good. I will rework it along with your suggestions below.

Fine. I had a look at their homepage, seems to be interesting hardware.

> 
> > > uioport is designed to be a setuid program and checks the permissions of
> > > the /dev/uio* node and if the user has write permissions it will use
> > > iopl and out*/in* to access the device.
> > 
> > What happens with PCI on PowerPC ?
> 
> I don't know. I could use /dev/port but my concern is that the device
> spec sheet specifies that some writes should be done with outb and
> others with outl. /dev/port only uses outb. Do you know if outl is
> different than four outb's to a device?

It is very probably different (4 WR pulses instead of one), the question
is if that causes different hardware behaviour. If there's a spec for it,
then you should definitly obey it.

What I had in mind was that those ioport regions cannot be mmapped on x86,
but it's possible on ppc, AFAIK.
Furthermore, you need to think about correct endianness handling.

Thanks,
Hans
