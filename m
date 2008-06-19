Return-Path: <linux-kernel-owner+w=401wt.eu-S1756333AbYFSVju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333AbYFSVju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 17:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbYFSVji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 17:39:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55650 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751227AbYFSVjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 17:39:37 -0400
Date: Thu, 19 Jun 2008 17:39:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthew Wilcox <matthew@wil.cx>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       <linux-kernel@vger.kernel.org>, <dsd@gentoo.org>,
       <mdharm-usb@one-eyed-alien.net>, <linux-usb@vger.kernel.org>,
       <vegardno@ifi.uio.no>, <James.Bottomley@HansenPartnership.com>,
       <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting
 root
In-Reply-To: <20080619182310.GA30833@parisc-linux.org>
Message-ID: <Pine.LNX.4.44L0.0806191735570.2229-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2008, Matthew Wilcox wrote:

> This discussion seemed to die off ... did anything ever come of it?

As I recall, it died because the whole notion was very poorly defined
to begin with.  The idea was to stop waiting when all the SCSI buses
had been scanned -- but there's no way to know when that occurs because
new buses can be added at any time.

Maybe a better approach would be to poll at reasonable intervals 
(HZ/10, for example) for the existence of the root device.  If it 
hasn't appeared after some reasonable time (30 seconds?) then give up.

Alan Stern

