Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbYK0Cmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbYK0Cmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 21:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbYK0CmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 21:42:22 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:42456 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbYK0CmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 21:42:21 -0500
Date: Wed, 26 Nov 2008 19:42:05 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Alex Chiang <achiang@hp.com>, "Darrick J. Wong" <djwong@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] fakephp: Allocate PCI resources before adding the	device
Message-ID: <20081127024204.GJ25548@parisc-linux.org>
References: <20081125212422.22631.69619.stgit@elm3a70.beaverton.ibm.com> <Pine.LNX.4.64.0811251919590.5161@t2.domain.actdsltmp> <20081126074808.GE6539@plum> <Pine.LNX.4.58.0811260131200.24816@shell4.speakeasy.net> <20081126181841.GF6539@plum> <Pine.LNX.4.58.0811261349120.24816@shell4.speakeasy.net> <20081126225535.GA27936@ldl.fc.hp.com> <Pine.LNX.4.58.0811261647410.24816@shell4.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0811261647410.24816@shell4.speakeasy.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 05:44:35PM -0800, Trent Piepho wrote:
> Is there a reason you had to change it?  It breaks an existing interface.
> It's clearly more inefficient and complicated to find a slot using it.  The
> exiting PCI device name, like "0000:01:00.0", has been used in the sysfs
> interface and with tools like lspci since forever.  Why should
> /sys/bus/pci/slots use different names from /sys/bus/pci/devices for the
> same device?

Because fakephp was the odd one out.  Every other hotplug driver
registers a slot number and puts the address in the directory.  We're
making hotplug drivers simpler (by sharing more of the logic in the
core) and so fakephp had to change to match the other drivers.  I'm
sorry for your inconvenience, but it's necessary.

We can discuss other ways to make your life better, but it can't be
changed back to one 'slot' per PCI function.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
