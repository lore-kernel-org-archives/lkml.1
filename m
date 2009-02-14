Return-Path: <linux-kernel-owner+w=401wt.eu-S1751898AbZBNIny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbZBNIny (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 03:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750926AbZBNInp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 03:43:45 -0500
Received: from www.tglx.de ([62.245.132.106]:48208 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbZBNIno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 03:43:44 -0500
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jan Engelhardt <jengelh@medozas.de>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, eparis@redhat.com, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCHv2 1/5] VFS: DazukoFS, stackable-fs, file access control
From: John Ogness <dazukocode@ogness.net>
References: <8663jrgwo4.fsf@johno.fn.ogness.net>
	<861vufgwlt.fsf@johno.fn.ogness.net>
	<alpine.LSU.2.00.0902121618500.5658@fbirervta.pbzchgretzou.qr>
	<86y6wagmmg.fsf@johno.fn.ogness.net>
	<alpine.LSU.2.00.0902132057300.15269@fbirervta.pbzchgretzou.qr>
	<20090213202523.GN28946@ZenIV.linux.org.uk>
Date: Sat, 14 Feb 2009 09:43:04 +0100
In-Reply-To: <20090213202523.GN28946@ZenIV.linux.org.uk> (Al Viro's message of "Fri\, 13 Feb 2009 20\:25\:23 +0000")
Message-ID: <86eiy1v27b.fsf@johno.fn.ogness.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-02-13, Al Viro <viro@ZenIV.linux.org.uk> wrote:
>> You could write an additional mount helper (and putting that into
>> /sbin/mount.dazukofs) that does all the security checks:
>> 
>>  - that the device is the same as mountpoint
>>  - that the device belonging to the underlying '/mnt' is not
>>    mounted anywhere else (in this namespace, at least)
>>  - exit(1) otherwise
>> 
>> Sure, it may not protect against all the cases Al can come up with,
>> but it is better than having nothing.
>
> It's still racy, at the very least.  Folks, seriously, you can not
> rely on the underlying tree being inaccessible elsewhere.  Anything
> that does stacking has to cope with that possibility; it's not
> bypassable by userland helpers.

Indeed. As long as the stackable filesystem is synchronizing with the
lower layer before doing read actions and synchronizes after all
actions, there should be no problem.

Currently I see a problem when a new directory is created directly on
the lower mount (rather than through the stackable filesystem). A
refcount for "." as seen from the stackable filesystem is then
incorrect. I will investigate this.

And I will look to see why there is any danger at all. There should
not be.

John Ogness
