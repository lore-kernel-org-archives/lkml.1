Return-Path: <linux-kernel-owner+w=401wt.eu-S1759171AbZBMUAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759171AbZBMUAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 15:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbZBMUAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 15:00:39 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:50067 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbZBMUAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 15:00:38 -0500
Date: Fri, 13 Feb 2009 21:00:36 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: John Ogness <dazukocode@ogness.net>
cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       malware-list@lists.printk.net, eparis@redhat.com, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCHv2 1/5] VFS: DazukoFS, stackable-fs, file access control
In-Reply-To: <86y6wagmmg.fsf@johno.fn.ogness.net>
Message-ID: <alpine.LSU.2.00.0902132057300.15269@fbirervta.pbzchgretzou.qr>
References: <8663jrgwo4.fsf@johno.fn.ogness.net> <861vufgwlt.fsf@johno.fn.ogness.net> <alpine.LSU.2.00.0902121618500.5658@fbirervta.pbzchgretzou.qr> <86y6wagmmg.fsf@johno.fn.ogness.net>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2009-02-13 20:31, John Ogness wrote:
>
>If we want to forbid users from being able to do this, I think it
>would be simpler just to fail the mount if it is _not_ specified for
>direct stacking. This forces users to use a syntax that makes it very
>clear what they are doing.
>
>Since mounting to a different directory could cause problems, I think
>it will be good to forbid it. I will make this change for the next
>patch series.

You could write an additional mount helper (and putting that into
/sbin/mount.dazukofs) that does all the security checks:

 - that the device is the same as mountpoint
 - that the device belonging to the underlying '/mnt' is not
   mounted anywhere else (in this namespace, at least)
 - exit(1) otherwise

Sure, it may not protect against all the cases Al can come up with,
but it is better than having nothing.
