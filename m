Return-Path: <linux-kernel-owner+w=401wt.eu-S934288AbZJGQff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934288AbZJGQff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 12:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934245AbZJGQfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 12:35:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35057 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933702AbZJGQfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 12:35:32 -0400
Date: Wed, 7 Oct 2009 12:34:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Alan Cox <alan@linux.intel.com>, <greg@kroah.com>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 4/5] usb_serial: Kill port mutex
In-Reply-To: <200910071810.02966.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0910071233240.2762-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Oct 2009, Oliver Neukum wrote:

> Am Mittwoch, 7. Oktober 2009 18:03:08 schrieb Alan Stern:
> > On Wed, 7 Oct 2009, Oliver Neukum wrote:
> > > We will need some generic way to autoresume from open.
> > > Resume will need to lock against open() and need to be called
> > > from within open(). Any ideas for an unugly interface?
> >
> > It's not quite that bad.  Resume doesn't need to lock against open.
> > If open is called while resume is running then when it tries to do its
> > own resume, it will either block (waiting for the pm_mutex) or return
> > immediately (if it sees the device is already resumed).
> 
> But resume() needs to know whether the read URBs need to be
> submitted or not.

Given that there are several pathways for turning on or turning off the 
read URBs, the best answer is to use a flag.

Alan Stern

