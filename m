Return-Path: <linux-kernel-owner+w=401wt.eu-S1751650AbZLZEUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbZLZEUY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 23:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751115AbZLZEUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 23:20:23 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41409 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750995AbZLZEUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 23:20:22 -0500
X-Sasl-enc: nEE19jE1caMsyaA+Z+NXQyM4/mnT92ILMzDekbuxk4hH 1261801220
Date: Sat, 26 Dec 2009 02:20:17 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Joe Perches <joe@perches.com>
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
       Len Brown <len.brown@intel.com>, ibm-acpi-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thinkpad_acpi.c: Remove #define TPACPI_<level>s for
 printks
Message-ID: <20091226042017.GA14921@khazad-dum.debian.net>
References: <1261797801.2568.69.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261797801.2568.69.camel@Joe-Laptop.home>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Dec 2009, Joe Perches wrote:
> The use of printk(TPACPI_<level> is unusual.
> Make it a bit more kernel normal style.

NAK.

This is likely purely a taste thing, but I completely fail to see how this:

> -	printk(TPACPI_DEBUG "%s: access by process with PID %d\n",
> -		what, task_tgid_vnr(current));
> +	printk(KERN_DEBUG pr_fmt("%s: access by process with PID %d\n"),
> +	       what, task_tgid_vnr(current));

is a good thing at all.  Maybe you could convince me to change my mind about
it but I dislike the resuling uglyness, so I will need a good technical
reason to even consider it.

Why would I want a parameter macro instead of a straightforward bunch of
#defines ?  It is not like the #defines are harder to understand than this
pr_fmt thing.

>  	if (!*fmt) {
> -		printk(TPACPI_ERR "acpi_evalf() called with empty format\n");
> +		pr_err("acpi_evalf() called with empty format\n");
>  		return 0;

I am with Peter Zijlstra on this one.  I don't want the pr_foo() siliness in
code I maintain.  You could perhaps convince me to change what is inside the
printk(), but the fact that my printk helpers end with "_printk" is not a
coincidence.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
