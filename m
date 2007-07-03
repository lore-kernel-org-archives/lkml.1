Return-Path: <linux-kernel-owner+w=401wt.eu-S1760297AbXGCWVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760297AbXGCWVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 18:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbXGCWVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 18:21:45 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38651 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754443AbXGCWVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 18:21:44 -0400
Date: Tue, 3 Jul 2007 18:21:42 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: linux-kernel@vger.kernel.org, <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM
 pathway
In-Reply-To: <20070703212002.GA28895@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.0707031814440.8010-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2007, Matthew Garrett wrote:

> On Tue, Jul 03, 2007 at 05:16:37PM -0400, Alan Stern wrote:
> > On Tue, 3 Jul 2007, Matthew Garrett wrote:
> > > But that's fine - "Are we undergoing a systemwide suspend" is an easy 
> > > question to ask. Freezing processes instead means that most of those 
> > > paths will never be tested.
> > 
> > The question is easy to ask, but it's not so easy to figure out what
> > you should do if the answer is Yes.  Freezing processes instead means
> > that those "untested" paths -- in many, many drivers -- won't have to 
> > exist at all.
> 
> We're used to the idea of applications blocking when a resource they're 
> using goes away - NFS has done it forever. 

You persist in evading my point.  I'm not worried about applications;  
I'm worried about drivers.

Let me put it explicitly: You're writing a driver.  You're working on
the read, write, or probe method.  You add code to check if a system
sleep is underway.  Suppose the answer is Yes -- what does your driver
do next?

Make your answer as detailed as you reasonably can.  And be careful to 
arrange things so that an ongoing I/O operation doesn't get messed up 
when your suspend method is called.

Alan Stern

