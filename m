Return-Path: <linux-kernel-owner+w=401wt.eu-S932871AbZJFP7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932871AbZJFP7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932837AbZJFP7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:59:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932799AbZJFP7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:59:39 -0400
Date: Tue, 6 Oct 2009 08:58:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: James Bottomley <James.Bottomley@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] SCSI fixes for 2.6.32-rc3
In-Reply-To: <1254844007.4383.85.camel@mulgrave.site>
Message-ID: <alpine.LFD.2.01.0910060851590.3432@localhost.localdomain>
References: <1254844007.4383.85.camel@mulgrave.site>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Oct 2009, James Bottomley wrote:
>
> This is mostly fixes.  However, it contains two new drivers: Brocade SAS
> (bfa), the Bladengine2 iSCSI (be2iscsi) under the merge window exemption

Btw, I'm getting less excited about the merge window exemption.

It makes sense for consumer devices that people actually hit and that are 
needed for bringup (ie they make a difference between a system that can be 
installed and used, and one that cannot), but I'm not at all sure it makes 
sense for things like this.

The _reason_ for the driver exemption was the fact that even a broken 
driver is better than no driver at all for somebody who just can't get a 
working system without it, but that argument really goes away when the 
driver is so specialized that it's not about regular hardware any more.

And the whole "driver exemption" seems to have become a by-word for "I can 
ignore the merge window for 50% of my code". Which makes me very tired of 
it if there aren't real advantages to real users.

So I'm seriously considering a "the driver has to be mass market and also 
actually matter to an install" rule for the exemption to be valid.

			Linus
