Return-Path: <linux-kernel-owner+w=401wt.eu-S937043AbXHHUIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937043AbXHHUIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 16:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762963AbXHHUIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 16:08:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:32815 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761981AbXHHUIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 16:08:01 -0400
Date: Wed, 8 Aug 2007 16:07:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Greg KH <gregkh@suse.de>, Mark Hindley <mark@hindley.org.uk>,
       Eric Biederman <ebiederm@xmission.com>, <kexec@lists.infradead.org>
Subject: Re: [3/3] 2.6.23-rc2: known regressions v2
In-Reply-To: <46B9F983.9020700@googlemail.com>
Message-ID: <Pine.LNX.4.44L0.0708081557450.3925-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007, Michal Piotrowski wrote:

> USB
> 
> Subject         : 2.6.23-rc1: uhci_hcd. irq 4: nobody cared
> References      : http://lkml.org/lkml/2007/7/29/75
> Last known good : ?
> Submitter       : Mark Hindley <mark@hindley.org.uk>
> Caused-By       : ?
> Handled-By      : Alan Stern <stern@rowland.harvard.edu>
> Status          : unknown

Mark has determined that this is not a regression but rather an 
already-existing problem, caused by invoking kexec from within an xterm 
window.  See

	http://marc.info/?l=linux-usb-users&m=118648557203179&w=2

Of course, this means there's liable to be something wrong with the way
kexec interacts with uhci-hcd or the other drivers sharing the same 
IRQ.  Failure to call the shutdown() method could cause the problem.  
But I don't see why using an xterm should make any difference (unless 
the only device being used was a mouse, and it was not in use while X 
wasn't running).

Alan Stern

