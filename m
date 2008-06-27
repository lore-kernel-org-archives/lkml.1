Return-Path: <linux-kernel-owner+w=401wt.eu-S1759631AbYF0U1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759631AbYF0U1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbYF0U1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:27:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46933 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbYF0U1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:27:43 -0400
Date: Fri, 27 Jun 2008 13:25:03 -0700
From: Greg KH <greg@kroah.com>
To: Benny Halevy <bhalevy@panasas.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: fix uninitialized variables in keyspan_pda
Message-ID: <20080627202503.GC15414@kroah.com>
References: <4864944B.5020601@panasas.com> <1214553534-9970-1-git-send-email-bhalevy@panasas.com> <20080627095816.4b9c8a2e@lxorguk.ukuu.org.uk> <4864B158.6080301@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4864B158.6080301@panasas.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 12:22:32PM +0300, Benny Halevy wrote:
> On Jun. 27, 2008, 11:58 +0300, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > On Fri, 27 Jun 2008 10:58:54 +0300
> > Benny Halevy <bhalevy@panasas.com> wrote:
> > 
> >> The compiler (gcc 4.3.0) warns that status might be used uninitialized
> >> in keyspan_pda_tiocmget and keyspan_pda_tiocmset.
> >>
> >> It is technically correct and therefore this patch initializes
> >> status to 0 in both cases.
> >>
> >> Note that keyspan_pda_get_modem_info sets *value only when
> >> usb_control_msg returns rc > 0, otherwise it must
> >> return an error rc < 0, and it must never return rc == 0, hence
> >> a WARN_ON(rc == 0) was added in case usb_control_msg ever return 0.
> > 
> > That seems like overkill - and by forcing status to 0 you will hide
> > future gcc error catches. Far better to change the two callers to test
> > for > 0 not >= 0 surely ?
> 
> Well, since usb_control_msg is not supposed to ever return 0
> I'm really not sure what to do if it does. I'll gladly defer that
> decision to Greg...

It's not supposed to return 0 unless you pass in 0 as the length to be
transferred (not likely, but possible.)  So I'm referring to the case in
the keyspan driver where the return value can not be zero, sorry for any
confusion.

> The following patch makes gcc happy as you said and if it's
> correct I, too, like it much better.

I like it better too, make it more obvious.

thanks,

greg k-h
