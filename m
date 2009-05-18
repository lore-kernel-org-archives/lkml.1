Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbZERMqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbZERMqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 08:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbZERMqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 08:46:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:50618 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbZERMqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 08:46:38 -0400
Subject: Re: [patch 06/51] usb-serial: ftdi_sio: fix reference counting of
 ftdi_private
From: David Woodhouse <dwmw2@infradead.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>
In-Reply-To: <20090514223521.148009855@mini.kroah.org>
References: <20090514223235.348540705@mini.kroah.org>
	 <20090514223521.148009855@mini.kroah.org>
Content-Type: text/plain
Date: Mon, 18 May 2009 13:46:32 +0100
Message-Id: <1242650792.30251.46.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-14 at 15:32 -0700, Greg KH wrote:
> 2.6.29-stable review patch.  If anyone has any objections, please let
> us know.
> 
> ------------------
> 
> From: Alan Stern <stern@rowland.harvard.edu>
> 
> commit c45d63202fbaccef7ef7946c03f27f72c809b1cc upstream.
> 
> This patch (as1238) adds proper reference counting for ftdi_sio's
> private data structure.  Without it, the driver will free the
> structure while it is still in use if the user unplugs the serial
> device before closing the device file.
> 
> The patch also replaces a slightly dangerous
> cancel_delayed_work/flush_scheduled_work pair with
> cancel_delayed_work_sync, which is always safer.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Reported-by: Daniel Mack <daniel@caiaq.de>
> Tested-by: Daniel Mack <daniel@caiaq.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Works for me as long as you include the incremental patch I just sent.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

