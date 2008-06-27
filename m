Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbYF0EUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbYF0EUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 00:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYF0EU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 00:20:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52958 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbYF0EU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 00:20:26 -0400
Date: Thu, 26 Jun 2008 21:17:35 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Benny Halevy <bhalevy@panasas.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: keyspan_pda.c use of keyspan_pda_get_modem_info
Message-ID: <20080627041735.GB8145@kroah.com>
References: <4863AD33.3070005@panasas.com> <20080626162346.5c324701@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080626162346.5c324701@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 04:23:46PM +0100, Alan Cox wrote:
> > In these two call sites the callers bail out if
> > keyspan_pda_get_modem_info return value is < 0
> 
> I don't think that is what the compiler is warning about.
> 
> We error on rc < 0
> We use the returned status on rc >= 0
> 
> We set the returned status on rc > 0
> 
> So the rc = 0 case is broken and gcc seems to be correct about that

Yes, that is correct, fortunatly that function can never return rc = 0,
so this will not happen in real life.

But there is really no way the compiler can ever figure that out, so I
don't blame it for complaining.

If you want to make a simple patch to make the compiler happy and be
quiet about the warning, I'll take it.

thanks,

greg k-h
