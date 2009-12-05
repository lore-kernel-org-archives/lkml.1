Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbZLERQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbZLERQO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 12:16:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756443AbZLERQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 12:16:13 -0500
Received: from netrider.rowland.org ([192.131.102.5]:52759 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753590AbZLERQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 12:16:12 -0500
Date: Sat, 5 Dec 2009 12:16:13 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Andreas Mohr <andi@lisas.de>
cc: Ondrej Zary <linux@rainbow-software.org>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: debugging oops after disconnecting Nexio USB touchscreen
In-Reply-To: <20091205073652.GA30203@rhlx01.hs-esslingen.de>
Message-ID: <Pine.LNX.4.44L0.0912051211530.15558-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Dec 2009, Andreas Mohr wrote:

> Hi,
> 
> > Furthermore, the patch shows that the second-to-last argument to 
> > usb_fill_bulk_urb() -- the completion function -- is NULL.  That is 
> > strictly illegal and it should have caused an oops as soon as the URB 
> > was used.
> 
> Then there's definitely a WARN_ON or so missing in
> static inline void usb_fill_bulk_urb()

No there isn't.  That inline just fills in a bunch of fields.

You could argue that there is a WARN_ON missing in usb_submit_urb().  
I don't think one is necessary, but you might disagree.  Either way,
both of us missed the fact that right at the start of usb_submit_urb()
is a check for urb->complete being NULL; if it is NULL then the
submission simply fails (and there is no oops).

> And highly likely more checks in those areas that are causing my (and
> other people's) ftdi_sio tests and USB audio (MIPS mmap) to fail.
> Followup soon.

Sometimes having too many checks is worse than having too few, 
especially if the failure modes are relatively easy to handle.

Alan Stern

