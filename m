Return-Path: <linux-kernel-owner+w=401wt.eu-S933739AbXF2QYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933739AbXF2QYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 12:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765749AbXF2QYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 12:24:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39410 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932775AbXF2QYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 12:24:33 -0400
To: Greg Huber <ghuber@vanteon.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Assistance debugging a Micrel network driver
References: <468527A2.40909@vanteon.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 29 Jun 2007 19:20:09 +0200
In-Reply-To: <468527A2.40909@vanteon.com>
Message-ID: <p73ejju4r06.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Huber <ghuber@vanteon.com> writes:
> 
> The upper layers obviously work so I'm sure it's something in my driver.

netstat -s output might give some clue. Most packet drop
points have a counter.

> 
> I have turned on as much debugging in the kernel as I could find, but
> I get no messages. Could someone please let me know if
> there is additional debugging I should consider or if there is a
> dynamic way to turn on debugging in L2 and/or L3.

The usual is to just add printks to the kernel source code until you
find where the packet is dropped.

Or perhaps check in __kfree_skb if the skb is coming from your
driver and force a backtrace with show_stack().

-Andi
