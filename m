Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbZGGUwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbZGGUwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 16:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755296AbZGGUwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 16:52:13 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:50278 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbZGGUwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 16:52:12 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Null Pointer BUG in uhci_hcd
Date: Tue, 7 Jul 2009 15:52:06 -0500
User-Agent: KMail/1.9.9
Cc: Oliver Neukum <oliver@neukum.org>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.0907071559410.8221-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0907071559410.8221-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907071552.09196.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue July 7 2009, Alan Stern wrote:
> On Tue, 7 Jul 2009, Michael S. Zick wrote:
> 
> > Will add that to my list - -
> > I need to do that to find/fix that error path message flood loop in ehci anyway.
> 
> What EHCI message flood?
> 

Give me a chance to test what you have already put on my plate.
It isn't very interesting - when the driver shuts down a hub
for "problems found" (I can't be more specific at the moment)
It will try to immediately after resume the hub;
Which leads to it taking the hub out of service;
Which leads to it trying to resume the hub;
etc. etc. etc.
That message flood in the error recovery path.

Set: ignore_oc=1 on the command line and that will stop the flood
at the first message - but only because it hard-locks the kernel with irq's disabled.

On this machine, the "over current" sense is a false indication -
something is not within the expected range.

Thank goodness, no one has asked me to get this kernel certified
for life-support use (not possible, the VIA silicon isn't certified either).  ;)

Mike
> Alan Stern
> 
> 
> 


