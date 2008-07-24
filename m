Return-Path: <linux-kernel-owner+w=401wt.eu-S1752491AbYGXDmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbYGXDmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 23:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbYGXDmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 23:42:14 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3945 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751021AbYGXDmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 23:42:13 -0400
Date: Wed, 23 Jul 2008 23:42:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Robert Hancock <hancockr@shaw.ca>
cc: Tomas Styblo <tripie@cpan.org>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>, <usb-storage@lists.one-eyed-alien.net>
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix - device
 152d:2338
In-Reply-To: <4887BCB9.2000103@shaw.ca>
Message-ID: <Pine.LNX.4.44L0.0807232337110.25883-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2008, Robert Hancock wrote:

> It remains an issue, though, that if there's no underflow, if the device 
> reports an error in the CSW but doesn't provide sense data, we assume 
> nothing bad happened and don't retry. That definitely does not seem 
> correct. The device is not supposed to do this, but with how crappily 
> some of these devices are designed we should be more defensive.

The problem is, what can you do?  The device has said that something 
was wrong, but it hasn't told you what.  Without knowing what went 
wrong, you can't know how to recover.

I suppose in such cases we could simply report that the command failed
completely.

> It's pretty gross to add random delays in without some good evidence or 
> input from the manufacturer that it will really fix the problem. (We do 
> have one GO_SLOW flag with a delay in there already for some Genesys 
> chips, but I believe that was based on some actual input from Genesys.)

That's right.

Alan Stern

