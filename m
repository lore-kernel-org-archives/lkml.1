Return-Path: <linux-kernel-owner+w=401wt.eu-S2993061AbXDRTSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993061AbXDRTSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 15:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993063AbXDRTSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 15:18:25 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4661 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993061AbXDRTSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 15:18:24 -0400
Date: Wed, 18 Apr 2007 20:18:12 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       izumi <izumi2005@soft.fujitsu.com>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
Subject: Re: [PATCH][BUG] Fix possible NULL pointer access in 8250 serial driver
Message-ID: <20070418191812.GA21211@flint.arm.linux.org.uk>
Mail-Followup-To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	izumi <izumi2005@soft.fujitsu.com>, linux-kernel@vger.kernel.org,
	linux-serial@vger.kernel.org
References: <46242DD2.7030207@soft.fujitsu.com> <20070416225206.cf7d8cd2.akpm@linux-foundation.org> <1176884513.3945.54.camel@kane-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1176884513.3945.54.camel@kane-linux>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2007 at 05:21:53PM +0900, Kenji Kaneshige wrote:
> > I'd imagine that other serial drivers might get upset having their
> > ->get_mcrtl() called prior to being opened.  Perhaps we should be fixing
> > this in uart_read_proc()?
> > 
> 
> I looked at other serial drivers and I could not find any other
> drivers which accesses port->info in their ->get_mctrl(). This 
> is why we fix this problem in 8250 driver. But if there is a
> possibility that other drivers accesses port->info in their
> ->get_mctrl(), we should be fixing this in uart_read_proc(), as
> you said.

NAK.  This means that you change the list of ports available on the
machine to be limited to only those which are currently open.  Utterly
useless for debugging, where you normally want people to dump the
contents of /proc/tty/driver/*.

The original patch was better.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
