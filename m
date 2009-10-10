Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbZJJWxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbZJJWxJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 18:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754415AbZJJWxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 18:53:09 -0400
Received: from netrider.rowland.org ([192.131.102.5]:44006 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754290AbZJJWxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 18:53:08 -0400
Date: Sat, 10 Oct 2009 18:52:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Josua Dietze <digidietze@draisberghof.de>, Ben Efros <ben@pc-doctor.com>,
       fangxiaozhi <huananhu@huawei.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Hugh Blemings <hugh@blemings.org>
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2
In-Reply-To: <1255211783.3387.14.camel@pasglop>
Message-ID: <Pine.LNX.4.44L0.0910101851430.7922-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Oct 2009, Benjamin Herrenschmidt wrote:

> 
> > Further REQUEST SENSE commands therefore requested 96 bytes of data
> > instead of the standard 18 bytes.  With LUN 0 this worked okay.  But 
> > with LUN 1 it didn't; the device reported a failure of the REQUEST 
> > SENSE.  This is what caused usb-storage to issue the device reset.
> > 
> > After the reset usb-storage continued to ask for 96 bytes of sense
> > data, and LUN 1 continued to fail the commands.  Hence the repeated
> > resets.
> 
> Maybe a better approach would be to go back to 18 bytes when it fails,
> what do you think ?

We certainly could do that.  But should we turn off the SANE_SENSE flag 
at the same time?

Alan Stern

