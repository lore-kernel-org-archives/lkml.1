Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbYAEQRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbYAEQRL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 11:17:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755051AbYAEQRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 11:17:00 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:34235 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426AbYAEQQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 11:16:59 -0500
Date: Sat, 5 Jan 2008 18:16:57 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       david-b@pacbell.net
Subject: Re: 2.6.24-rc6-mm1 (build problem: gpio/W1)
Message-ID: <20080105161657.GQ15861@sci.fi>
References: <20071222233056.d652743e.akpm@linux-foundation.org> <20071231101920.5fb60a3d.randy.dunlap@oracle.com> <20080105152904.GB12982@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080105152904.GB12982@2ka.mipt.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2008 at 06:29:04PM +0300, Evgeniy Polyakov wrote:
> Hi Randy.
> 
> Sorry for long delay.
> 
> On Mon, Dec 31, 2007 at 10:19:20AM -0800, Randy Dunlap (randy.dunlap@oracle.com) wrote:
> >   CC      drivers/w1/masters/w1-gpio.o
> > In file included from /local/linsrc/linux-2.6.24-rc6-mm1/drivers/w1/masters/w1-gpio.c:19:
> > include2/asm/gpio.h:4:18: error: gpio.h: No such file or directory
> > /local/linsrc/linux-2.6.24-rc6-mm1/drivers/w1/masters/w1-gpio.c: In function 'w1_gpio_write_bit_dir':
> > /local/linsrc/linux-2.6.24-rc6-mm1/drivers/w1/masters/w1-gpio.c:26: error: implicit declaration of function 'gpio_direction_input'
> > /local/linsrc/linux-2.6.24-rc6-mm1/drivers/w1/masters/w1-gpio.c:28: error: implicit declaration of function 'gpio_direction_output'
> 
> I believe w1-gpio it has to depend on generic gpio, Ville can you
> confirm that?

The dependency is there:

config W1_MASTER_GPIO
	tristate "GPIO 1-wire busmaster"
	depends on GENERIC_GPIO

So it looks like the arch Kconfig has selected GENERIC_GPIO but failed
to provide the implementation.

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
