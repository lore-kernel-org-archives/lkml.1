Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbYLACLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbYLACLk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 21:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbYLACLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 21:11:31 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45485 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbYLACLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 21:11:30 -0500
Date: Mon, 1 Dec 2008 11:10:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, gregkh@suse.de
Subject: Re: mmotm 2008-11-29-01-53 uploaded
Message-Id: <20081201111040.42b2a908.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200811290959.mAT9xuhC004277@imap1.linux-foundation.org>
References: <200811290959.mAT9xuhC004277@imap1.linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2008 01:59:56 -0800
akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2008-11-29-01-53 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> It contains the following patches against 2.6.28-rc6:
> 
Hi, in recent changes of linux-next.patch

==
static void __init param_sysfs_builtin(void)
{
        struct kernel_param *kp;
        unsigned int name_len;
        char modname[MODULE_NAME_LEN];

        for (kp = __start___param; kp < __stop___param; kp++) {
                char *dot;

                if (kp->perm == 0)
                        continue;

                dot = strchr(kp->name, '.');
                BUG_ON(!dot); <======================================(*)
                name_len = dot - kp->name + 1;
                strlcpy(modname, kp->name, name_len);
                kernel_add_sysfs_param(modname, kp, name_len);
        }

==
Above (*) is added.

I hit BUG_ON() at (*). That was because usbcore was not a module and module param
kp->name was "nousb".... not including any dot.
(If compled as module, the kernel works well.)

I'm sorry if already fixed.

Thanks,
-Kame







