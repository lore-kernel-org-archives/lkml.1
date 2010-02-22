Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab0BVTOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 14:14:48 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:48824 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370Ab0BVTOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 14:14:44 -0500
Date: Mon, 22 Feb 2010 19:14:32 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Anssi Hannula <anssi.hannula@iki.fi>, Oliver Neukum <oliver@neukum.org>,
       dvomlehn@cisco.com, gregkh@suse.de, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial
	writes" causes gobi_loader to hang
Message-ID: <20100222191432.GA27418@srcf.ucam.org>
References: <201002222035.36043.anssi.hannula@iki.fi> <Pine.LNX.4.44L0.1002221408200.1251-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1002221408200.1251-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 02:10:33PM -0500, Alan Stern wrote:
> On Mon, 22 Feb 2010, Anssi Hannula wrote:
> > Does this mean a tty interface is ill-suited for the microcode upload, and 
> > instead qcserial should use the kernel's generic microcode upload mechanism or 
> > the userspace should use libusb to do it?
> 
> I don't know.  Didn't the old successful code use a tty interface?

Yes. The kfifo changes have caused some sort of alteration in behaviour.

> > Any idea what could be causing the hang, then?
> 
> No idea, unless it's the device.

Once the device hangs, it then tends to refuse any input until power 
cycled. So it's clearly getting into some sort of undefined state, 
though whether that's because it only gets sent half of its firmware 
(ie, the hang occurs and as a result the hardware dies) or whether it's 
causing the hang by dying is unclear.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
