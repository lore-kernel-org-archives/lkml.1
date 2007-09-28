Return-Path: <linux-kernel-owner+w=401wt.eu-S1760190AbXI0XHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760190AbXI0XHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 19:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759534AbXI0XHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 19:07:03 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:46595
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752372AbXI0XHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 19:07:01 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [Announce] Linux-tiny project revival
Date: Thu, 27 Sep 2007 19:06:48 -0500
User-Agent: KMail/1.9.6
Cc: linux-tiny@selenic.com, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       Michael Opdenacker <michael@free-electrons.com>
References: <46F1645D.9050406@am.sony.com> <200709201538.43093.rob@landley.net> <200709270900.36602.arnd@arndb.de>
In-Reply-To: <200709270900.36602.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709271906.48601.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 September 2007 2:00:36 am Arnd Bergmann wrote:
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

The "change every printk in the kernel" suggestion came from me trying to 
figure out how to get the printk() calls below a certain log level to 
optimize out and not take up space in the binary.

The above doesn't address the original cause of the thread, as far as I can 
tell.

> 	Arnd <><

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
