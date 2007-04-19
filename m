Return-Path: <linux-kernel-owner+w=401wt.eu-S1161140AbXDSGyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161140AbXDSGyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 02:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161130AbXDSGyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 02:54:09 -0400
Received: from smtp-104-thursday.nerim.net ([62.4.16.104]:2287 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161140AbXDSGyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 02:54:08 -0400
Date: Thu, 19 Apr 2007 08:54:13 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Brownell <david-b@pacbell.net>, Bryan Wu <bryan.wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org,
       Christer Weinigel <wingel@nano-system.com>,
       Jordan Crouse <jordan.crouse@amd.com>
Subject: Re: [PATCH v3] Bitbanging i2c bus driver using the GPIO API
Message-ID: <20070419085413.1520feef@hyperion.delvare>
In-Reply-To: <20070418174256.GB5577@csclub.uwaterloo.ca>
References: <11765554074106-git-send-email-hskinnemoen@atmel.com>
	<20070414163418.20490fe2@dhcp-252-105.norway.atmel.com>
	<20070414192807.60bdf84b@hyperion.delvare>
	<20070418174256.GB5577@csclub.uwaterloo.ca>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

On Wed, 18 Apr 2007 13:42:56 -0400, Lennart Sorensen wrote:
> On Sat, Apr 14, 2007 at 07:28:07PM +0200, Jean Delvare wrote:
> > Otherwise it looks OK to me, I take the patch. If others have comments
> > or objections, just speak up and submit incremental patches as needed.
> > 
> > Now I would like to see platform code actually using this.
> 
> Any idea how similar this new driver is to the scx200_i2c driver?  As
> far as I can tell that driver is already a bit banged i2c over gpio
> lines.

The major difference is that the implementation in scx200_i2c is
hardware-specific, while the i2c-gpio driver is a generic one, so it's
a lot better.

What this means is that i2c-gpio obsoletes scx200_i2c, so I am inclined
to delete scx200_i2c right away. I'm not even sure anyone still uses it
now that scx200_acb has been fixed and is reported to work very well.
If anyone really needs to do I2C over GPIO pins on SCx200, this should
be reimplemented on top of i2c-gpio.

It also looks to me like i2c-ixp2000 and i2c-ixp4xx are obsoleted by
i2c-gpio. Deepak, can you please try using i2c-gpio instead and confirm
that i2c-ixp2000 and i2c-ixp4xx can be deleted?

Thanks,
-- 
Jean Delvare
