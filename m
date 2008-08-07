Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbYHGOR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbYHGOR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 10:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbYHGORG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 10:17:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45368 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752400AbYHGORE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 10:17:04 -0400
Date: Thu, 7 Aug 2008 10:17:04 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, <ospite@studenti.unina.it>, <matthew@wil.cx>,
       <nickpiggin@yahoo.com.au>
Subject: Re: BUG in VFS or block layer
In-Reply-To: <20080806155547.619f13f8.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0808071014550.2598-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008, Andrew Morton wrote:

> > > So...  would you be able to verify that the USB, layer is correctly
> > > calling bio->bi_end_io() for the offending requests?
> > 
> > The USB layer doesn't handle that; the SCSI layer takes care of it.  
> > Possibly the I/O error confuses the code in and around 
> > scsi_end_request().  I'll have to do some testing to find out.
> > 
> 
> Well...  looking at your patch to
> drivers/usb/gadget/file_storage.c:do_read(), it appears that
> do_scsi_command() just drops do_read()'s error code on the floor rather
> than returning it to the scsi layer?

No, you misunderstand.  file_storage.c is a peripheral driver, not a
host device driver.  It doesn't communicate directly with the SCSI
layer and it doesn't handle any BIO requests.  You're thinking of
usb-storage, not file_storage.

Alan Stern

