Return-Path: <linux-kernel-owner+w=401wt.eu-S1031430AbXEDRMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031430AbXEDRMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031435AbXEDRMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:12:10 -0400
Received: from mail.samba.org ([66.70.73.150]:53288 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031430AbXEDRMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:12:08 -0400
Date: Fri, 4 May 2007 10:12:00 -0700
From: Jeremy Allison <jra@samba.org>
To: Gerald Carter <coffeedude.jerry@gmail.com>
Cc: simo <idra@samba.org>, Christoph Hellwig <hch@infradead.org>,
       Steve French <smfrench@gmail.com>, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-cifs-client] Re: SMB2 file system - should it be a	distinct module
Message-ID: <20070504171200.GE31976@samba1>
Reply-To: Jeremy Allison <jra@samba.org>
References: <524f69650704301552j13cd46e5y53a233af753e0548@mail.gmail.com> <20070501090657.GA17949@infradead.org> <1178198489.28758.14.camel@localhost.localdomain> <20070503141742.GB20328@infradead.org> <1178203013.28758.29.camel@localhost.localdomain> <4639F5AD.20807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4639F5AD.20807@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 09:46:05AM -0500, Gerald Carter wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Simo,
> 
> > I guess DFS referrals can work cross protocol, so if you are redirected
> > from a longhorn server to a windoes 2000 or a samba server you want to
> > be able to follow the DFS referral and not return an error.
> > To do that you need to have either 1 module that support both protocols
> > or a way from one module to call the other. Just separating the 2
> > without any glue will not work (or you will have to add some userspace
> > upcall hack to make it work).
> 
> Long term I agree that CIFS and SMB2 should be in the same .ko

Actually I disagree. I think Christoph is correct. These
are two independent protocols and should be in two different
modules.

> But NTLM 0.12 still works for Vista and DFS referrals.
> Breaking out SMB2 initially means that it will not clutter
> the working cifs.ko code.  Remember that an SMB2 client fs is
> mostly research at this point, and not engineering.

Long term the common functions should be factored out
and put into a lower-level module that both cifs and
SMB2 are dependent upon.

That's the cleaner solution IMHO.

Jeremy.
