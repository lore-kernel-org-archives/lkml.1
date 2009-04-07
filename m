Return-Path: <linux-kernel-owner+w=401wt.eu-S1759659AbZDGBHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759659AbZDGBHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 21:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756633AbZDGBGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 21:06:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:40169 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756416AbZDGBGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 21:06:13 -0400
Date: Mon, 6 Apr 2009 18:02:31 -0700
From: Greg KH <gregkh@suse.de>
To: Elina <epasheva@sierrawireless.com>
Cc: rfiler@sierrawireless.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 003/003] USB:  serial: sierra driver bug fixes in
	open/close and callbacks
Message-ID: <20090407010231.GD2839@suse.de>
References: <1239062762.10120.38.camel@Linuxdev3>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1239062762.10120.38.camel@Linuxdev3>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06, 2009 at 05:06:02PM -0700, Elina wrote:
> Subject: [PATCH 003/003] USB:  serial: sierra driver bug fixes in 
> open/close and callbacks
> From: Elina Pasheva <epasheva@sierrawireless.com>
> 
> ﻿The series of 3 patches modify sierra usb serial driver with
> blacklisting of specific non-serial interfaces, bug fixing and
> performance improvements. 
> This is [PATCH 003/003]. This patch depends on [PATCH 002/003].
> The following is summary of changes we have made to sierra.c driver in
> [PATCH 003/003] dealing with bug fixes in open/close and callbacks:
> - Fixed a problem in sierra_send_setup() for composite modems. Should
> not be sending ACM commands to interfaces that are OBEX. Doing this
> causes an apparent failure as the ACM command has to time out before the
> interface can start being used
> ﻿- Fixed a problem in function sierra_indat_callback() which would stop
> receiving traffic from a modem if a number of URB failures occur. Failed
> URBs are not resubmitted for the next read and there is only a limited
> number of URBs allocated for the IN path. After this number of failures,
> the receive path stops working on a particular interface.
> - Moved allocation of memory-based items to Open function from the
> Startup function to conserve memory. This way, only interfaces that are
> active will allocate and use the memory instead of all the memory being
> allocated up front whether it would be needed or not

Again, please split this up into logical pieces.

thanks,

greg k-h
