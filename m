Return-Path: <linux-kernel-owner+w=401wt.eu-S1751864AbZHaKEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbZHaKEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 06:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbZHaKEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 06:04:51 -0400
Received: from bamako.nerim.net ([62.4.17.28]:61047 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbZHaKEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 06:04:50 -0400
Date: Mon, 31 Aug 2009 12:04:49 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: linux-next: i2c tree build failure
Message-ID: <20090831120449.3f64aa74@hyperion.delvare>
In-Reply-To: <20090831111935.5059565b.sfr@canb.auug.org.au>
References: <20090831111935.5059565b.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, 31 Aug 2009 11:19:35 +1000, Stephen Rothwell wrote:
> Hi Jean,
> 
> Today's linux-next build (powerpc ppc64_defconfig) failed like this:
> 
> drivers/i2c/i2c-core.c:234: warning: initialization from incompatible pointer type
> drivers/i2c/i2c-core.c:537: warning: initialization from incompatible pointer type
> drivers/i2c/i2c-core.c: In function 'i2c_register_adapter':
> drivers/i2c/i2c-core.c:603: error: implicit declaration of function 'class_compat_create_link'
> drivers/i2c/i2c-core.c: In function 'i2c_del_adapter':
> drivers/i2c/i2c-core.c:789: error: implicit declaration of function 'class_compat_remove_link'
> drivers/i2c/i2c-core.c: In function 'i2c_init':
> drivers/i2c/i2c-core.c:999: error: implicit declaration of function 'class_compat_register'
> drivers/i2c/i2c-core.c:999: warning: assignment makes pointer from integer without a cast
> drivers/i2c/i2c-core.c:1012: error: implicit declaration of function 'class_compat_unregister'
> 
> I have used the i2c tree from next-20090828 for today.

These are caused by the fact that I moved the patch adding
class_compat_create_link() and friends out of the NEXT_PATCHES section.
I did so because Greg KH (Cc'd) added this patch to his driver-core
patch set, which I thought was part of linux-next. I simply didn't want
to apply the same patch twice.

To clarify the dependency, I added the following to my series.conf:

# NEXT_BASE driver-core.current

but apparently it didn't work as intended.

Greg, please clarify whether the patch in question
(driver-core-add-support-for-compatibility-classes.patch) is pushed to
linux-next or not.

Stephen, if my dependency tag is not correct, please tell me how to fix
it.

Thanks, and sorry for the trouble.

-- 
Jean Delvare
