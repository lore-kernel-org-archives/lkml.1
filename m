Return-Path: <linux-kernel-owner+w=401wt.eu-S1758425AbXI0Qgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758425AbXI0Qgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 12:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756837AbXI0Qgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 12:36:37 -0400
Received: from neon.samage.net ([85.17.153.66]:49972 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753683AbXI0Qgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 12:36:36 -0400
Message-ID: <39129.81.207.0.53.1190910941.squirrel@secure.samage.net>
In-Reply-To: <200709270900.36602.arnd@arndb.de>
References: <46F1645D.9050406@am.sony.com>
    <200709201538.43093.rob@landley.net>
    <200709270900.36602.arnd@arndb.de>
Date: Thu, 27 Sep 2007 18:35:41 +0200 (CEST)
Subject: Re: [Announce] Linux-tiny project revival
From: "Indan Zupancic" <indan@nul.nu>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Rob Landley" <rob@landley.net>,
       "Michael Opdenacker" <michael@free-electrons.com>,
       linux-tiny@selenic.com,
       "CE Linux Developers List" <celinux-dev@tree.celinuxforum.org>,
       "linux kernel" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 0ccaee305be983877c9e38c09cbf8ec4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, September 27, 2007 09:00, Arnd Bergmann wrote:
> Assuming that we want to go down that road, I think you can do better with
> more evil macro magic, by using something along the lines of
>
> #define KERN_NOTICE "<5>",
>
> #define PRINTK_CONTINUED "",
>
>  #define printk(level, str, ...) \
>    do { \
>      if (sizeof(level) == 1) /* continued printk */\
> 	actual_printk(str, __VA_ARGS__); \
>      else if ((level[1] - '0') < CONFIG_PRINTK_DOICARE) \
>        actual_printk(level str, __VA_ARGS__); \
>    } while(0);
>
> Then you don't have to change every single printk in the kernel, but
> only those that don't currently come with a log level. More importantly,
> you can do the conversion without a flag day, by spreading (an empty)
> PRINTK_CONTINUED in places that do need a printk without a log level.

The problem is, how do you know whether to print a continued printk or not?
It depends on the loglevel of the first printk.

So besides compile-time parsing of the source code, replacing printk with
loglevel specific alternatives (one way or the other) seems the only option.

Greetings,

Indan


