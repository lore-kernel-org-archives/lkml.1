Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbYHXWPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbYHXWPy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 18:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbYHXWPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 18:15:45 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:54248 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbYHXWPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 18:15:45 -0400
Subject: Re: NFS regression? Odd delays and lockups accessing an NFS export.
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: John Ronciak <john.ronciak@gmail.com>, Grant Coady <gcoady.lk@gmail.com>,
       linux-kernel@vger.kernel.org, neilb@suse.de, bfields@fieldses.org,
       linux-nfs@vger.kernel.org, Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Bruce Allan <bruce.w.allan@intel.com>,
       PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       e1000-devel@lists.sourceforge.net
In-Reply-To: <1219615789.27921.152.camel@localhost.localdomain>
References: <p6lha4te54h04qdbnos1mcemdmn1cfca6s@4ax.com>
	 <1219087258.7192.19.camel@localhost>
	 <1219400624.18774.67.camel@zakaz.uk.xensource.com>
	 <1219428489.6919.21.camel@localhost>
	 <1219428818.27921.43.camel@localhost.localdomain>
	 <56a8daef0808221233h68853587n6015ca7d809b17e1@mail.gmail.com>
	 <1219435207.27921.51.camel@localhost.localdomain>
	 <1219440202.9097.14.camel@localhost>
	 <1219441041.27921.57.camel@localhost.localdomain>
	 <1219442213.9097.25.camel@localhost>
	 <1219603981.27921.145.camel@localhost.localdomain>
	 <1219605422.14389.2.camel@localhost>  <1219605596.14389.5.camel@localhost>
	 <1219615789.27921.152.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 24 Aug 2008 18:15:36 -0400
Message-Id: <1219616136.14389.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 5E9B7AD2A040987041CF7545EE92CCA3A43055AD
X-UiO-SPAM-Test: remote_host: 68.40.183.129 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 25 max/h 2 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-08-24 at 23:09 +0100, Ian Campbell wrote:
> (added some quoting from previous mail to save replying twice)
> 
> On Sun, 2008-08-24 at 15:19 -0400, Trond Myklebust wrote:
> > On Sun, 2008-08-24 at 15:17 -0400, Trond Myklebust wrote:
> > > >From the tcpdump, it looks as if the NFS server is failing to close the
> > > socket, when the client closes its side. You therefore end up getting
> > > stuck in the FIN_WAIT2 state (as netstat clearly shows above).
> > >
> > > Is the server keeping the client in this state for a very long
> > > period?
> 
> Well, it had been around an hour and a half on this occasion. Next time
> it happens I can wait longer but I'm pretty sure I've come back from
> time away and it's been wedged for at least a day. How long would you
> expect it to remain in this state for?

The server should ideally start to close the socket as soon as it
receives the FIN from the client. I'll have a look at the code.

Trond

