Return-Path: <linux-kernel-owner+w=401wt.eu-S1753583AbZERXif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbZERXif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 19:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbZERXiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 19:38:17 -0400
Received: from kroah.org ([198.145.64.141]:39538 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbZERXiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 19:38:16 -0400
Date: Mon, 18 May 2009 16:33:43 -0700
From: Greg KH <greg@kroah.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Greg KH <gregkh@suse.de>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>, Eugene Teo <eteo@redhat.com>,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Willy Tarreau <w@1wt.eu>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       akpm@linux-foundation.org, Jake Edge <jake@lwn.net>,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>
Subject: Re: [stable] [patch 06/51] usb-serial: ftdi_sio: fix reference
	counting of ftdi_private
Message-ID: <20090518233343.GB8754@kroah.com>
References: <20090514223235.348540705@mini.kroah.org> <20090514223521.148009855@mini.kroah.org> <1242650792.30251.46.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242650792.30251.46.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 18, 2009 at 01:46:32PM +0100, David Woodhouse wrote:
> On Thu, 2009-05-14 at 15:32 -0700, Greg KH wrote:
> > 2.6.29-stable review patch.  If anyone has any objections, please let
> > us know.
> > 
> > ------------------
> > 
> > From: Alan Stern <stern@rowland.harvard.edu>
> > 
> > commit c45d63202fbaccef7ef7946c03f27f72c809b1cc upstream.
> > 
> > This patch (as1238) adds proper reference counting for ftdi_sio's
> > private data structure.  Without it, the driver will free the
> > structure while it is still in use if the user unplugs the serial
> > device before closing the device file.
> > 
> > The patch also replaces a slightly dangerous
> > cancel_delayed_work/flush_scheduled_work pair with
> > cancel_delayed_work_sync, which is always safer.
> > 
> > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> > Reported-by: Daniel Mack <daniel@caiaq.de>
> > Tested-by: Daniel Mack <daniel@caiaq.de>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Works for me as long as you include the incremental patch I just sent.

I'll queue that one up for the next .29-stable release.

thanks,

greg k-h
