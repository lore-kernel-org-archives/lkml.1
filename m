Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbYGHSvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbYGHSvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 14:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbYGHSvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 14:51:03 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:1788 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbYGHSvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 14:51:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=kiNH6ol3AdEKLs1+hBw1pfUxXJD+hVLicuBNHHTyqh6RnxqDFMyy1IVuIcGH/M/kpD
         w8ELas1cHs21iPpjgcdtuhBRpUltKk4QTxE15f7Lkl0W3NgcuEW20mQXqP+30KI9gkXX
         ekwuUgc6DWgWD3jV7dVOxFGnwvrVQNuQ+bPFU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [regression] Re: 2.6.26-rc6: pcmcia stopped working
Date: Tue, 8 Jul 2008 20:06:37 +0200
User-Agent: KMail/1.9.9
Cc: kernel list <linux-kernel@vger.kernel.org>
References: <20080622224022.GA2066@elf.ucw.cz> <200807051448.40466.bzolnier@gmail.com> <20080705224631.GA32546@elf.ucw.cz>
In-Reply-To: <20080705224631.GA32546@elf.ucw.cz>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807082006.37847.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 July 2008, Pavel Machek wrote:
> Hi!
> 
> > > > > Hmm, hitting sysrq-w produces no blocked task until I eject pcmcia
> > > > > card. Backtrace there is:
> > > > > 
> > > > > Greg, I believe some traces lead to sysfs, can you help here?
> > > > 
> > > > ide_unregister() does not complete :-(.
> > > > 
> > > >         device_unregister(&hwif->gendev);
> > > > +       printk("ide_unregister: waiting for rel_comp\n");
> > > >         wait_for_completion(&hwif->gendev_rel_comp);
> > > > 
> > > > ...that wait_for_completion never returns.
> > 
> > [...]
> > 
> > Thanks for narrowing it down to wait_for_completion() call,
> > it was an useful hint.
> 
> Thanks for a patch, I'll test it soon. Here are two really trivial
> patches... maybe too trivial?

there are no too trivial patches in the git era :)

> ---
> 
> Small whitespace fixes for drivers/ide.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>

applied
