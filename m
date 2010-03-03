Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab0CCNPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 08:15:14 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:40642 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754105Ab0CCNPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 08:15:06 -0500
Date: Wed, 3 Mar 2010 16:15:04 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/12] ahci: Add support for non-PCI devices
Message-ID: <20100303131504.GA25973@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20100302182850.GA32057@oksana.dev.rtsoft.ru>
 <4B8D846F.3080400@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4B8D846F.3080400@garzik.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 04:34:39PM -0500, Jeff Garzik wrote:
[...]
> As demonstrated in libata-dev.git#libahci, I think the best route is
> to move generic code into libahci.  In #libahci you will see
> 
> 	libahci -> common code
> 	ahci -> standard PCI driver, req's libahci
> 	mv-ahci -> Marvell AHCI driver, req's libahci
> 	acard-ahci -> ACard AHCI driver, req's libahci
> 
> and to this we could easily add
> 
> 	platform-ahci -> platform AHCI driver, req's libahci
> 
> WARNING:  #libahci should not be used directly, it is meant for
> illustration purposes only.  It has not been properly updated for
> several recent ahci.c changes upstream, which implies that the
> trivial-and-obvious task of moving generic code from ahci.c to
> libahci.c must be redone.

Well, do I understand correctly that the only issue is the
file names? I.e. in my patches, instead of keeping the library
code in ahci.c, I should move the library code into libahci.c,
and keep the PCI code in ahci.c?

Because, as far as I can see, the result of my patches is pretty
much the same as in #libahci, except the file names and more
things that can be reused (i.e. ahci_sht, ahci_ops -- I kept
all this in the library part, since we want to share it with
the platform driver).

Also, I don't export function that aren't currently used
by PCI or platform drivers, but in #libahci there are all
exported. Should I keep it my way, or should I export all the
functions (even if there are no any users of these)?

> P.S.  Please use the email addresses in MAINTAINERS,
> 
> 	M:      Jeff Garzik <jgarzik@pobox.com>
> 	L:      linux-ide@vger.kernel.org
> 
> The redhat.com email address is only used for legal (sign-off)
> purposes, not normal use.

Got it, thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
