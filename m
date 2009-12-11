Return-Path: <linux-kernel-owner+w=401wt.eu-S1759252AbZLKSkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252AbZLKSkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 13:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758832AbZLKSkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 13:40:37 -0500
Received: from mail.perches.com ([173.55.12.10]:1080 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758538AbZLKSkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 13:40:36 -0500
Subject: Re: [PATCH] i2c-iop3xx.c: fix memory resource
From: Joe Perches <joe@perches.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-i2c@vger.kernel.org, khali@linux-fr.org,
       Ben Dooks <ben-linux@fluff.org>,
       Lennert Buytenhek <buytenh@wantstofly.org>, dan.j.williams@intel.com
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901FB1063@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE190901FB1063@mi8nycmail19.Mi8.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Dec 2009 10:40:42 -0800
Message-ID: <1260556842.18299.34.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-11 at 13:32 -0500, H Hartley Sweeten wrote:
> The i2c-iop3xx driver requires a resource region of 0x18 bytes and
> currently uses the magic number IOP3XX_I2C_IO_SIZE (defined in
> i2c-iop3xx.h) to indicate this.  All of the users of this driver
> have a platform memory resource so use resource_size() instead of
> the magic number.  This requires fixing a couple of the memory
> resources since they were either off by 1 or just wrong.
[]
>  static struct resource iop13xx_i2c_0_resources[] = {
>  	[0] = {
>  		.start = IOP13XX_I2C0_PHYS,
> -		.end = IOP13XX_I2C0_PHYS + 0x18,
> +		.end = IOP13XX_I2C0_PHYS + 0x17,

etc.

> -#define	IOP3XX_I2C_IO_SIZE	0x18

Maybe it's clearer to keep the IO_SIZE define
and let the compiler do the adding.

.start = FOO;
.end = FOO + IOP3XX_I2C_IO_SIZE - 1;

