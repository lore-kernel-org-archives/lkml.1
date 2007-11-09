Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbXKIRVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbXKIRVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 12:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbXKIRVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 12:21:46 -0500
Received: from mail.fieldses.org ([66.93.2.214]:60685 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbXKIRVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 12:21:45 -0500
Date: Fri, 9 Nov 2007 12:21:35 -0500
To: Przemyslaw Wegrzyn <czajnik@czajsoft.pl>
Cc: Steve French <smfrench@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, joern@logfs.org
Subject: Re: Fw: Buffer overflow in CIFS VFS.
Message-ID: <20071109172135.GD26826@fieldses.org>
References: <OFA6B04F1D.DE8E7DD9-ON8725738E.00065BC2-8625738E.00066CD4@us.ibm.com> <524f69650711081812j20580247kce68334b778c73c7@mail.gmail.com> <47343DA2.90306@czajsoft.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47343DA2.90306@czajsoft.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2007 at 11:59:46AM +0100, Przemyslaw Wegrzyn wrote:
> Steve French wrote:
> > You are correct that the CIFS code calls SendReceive in cases in which
> > the buffer may be too small to fit a large SMB response, and that
> > should be fixed (e.g. to avoid possible overflows due to a server
> > bug), None of the eight cases (SMB TreeDisconnect, SMB uLogoff, SMB
> > Close, SMB FindClose etc.) in which a small buffer is passed in to
> > SendReceive return more than a few dozen bytes (and they are fixed
> > size responses), but I agree that we have to be safe (and we have seen
> > at least one server corrupt the bcc in the ulogoffX response and
> > another on the NTCreateX response) so it would be good to fix.
> >   
> Well, mounting shares from untrusted server is quite uncommon, still
> buffer overrun shall be considered a serious issue, imho.

Also, a compromised machine on the same network could forge the
malicious reply in some cases, right?

--b.
