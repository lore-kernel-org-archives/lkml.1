Return-Path: <linux-kernel-owner+w=401wt.eu-S1761965AbZBMUZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761965AbZBMUZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 15:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbZBMUZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 15:25:26 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35465 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbZBMUZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 15:25:25 -0500
Date: Fri, 13 Feb 2009 20:25:23 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: John Ogness <dazukocode@ogness.net>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, eparis@redhat.com, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCHv2 1/5] VFS: DazukoFS, stackable-fs, file access control
Message-ID: <20090213202523.GN28946@ZenIV.linux.org.uk>
References: <8663jrgwo4.fsf@johno.fn.ogness.net> <861vufgwlt.fsf@johno.fn.ogness.net> <alpine.LSU.2.00.0902121618500.5658@fbirervta.pbzchgretzou.qr> <86y6wagmmg.fsf@johno.fn.ogness.net> <alpine.LSU.2.00.0902132057300.15269@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0902132057300.15269@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 09:00:36PM +0100, Jan Engelhardt wrote:

> You could write an additional mount helper (and putting that into
> /sbin/mount.dazukofs) that does all the security checks:
> 
>  - that the device is the same as mountpoint
>  - that the device belonging to the underlying '/mnt' is not
>    mounted anywhere else (in this namespace, at least)
>  - exit(1) otherwise
> 
> Sure, it may not protect against all the cases Al can come up with,
> but it is better than having nothing.

It's still racy, at the very least.  Folks, seriously, you can not
rely on the underlying tree being inaccessible elsewhere.  Anything
that does stacking has to cope with that possibility; it's not
bypassable by userland helpers.
