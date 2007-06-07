Return-Path: <linux-kernel-owner+w=401wt.eu-S1762291AbXFGO6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762291AbXFGO6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 10:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759970AbXFGO6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 10:58:10 -0400
Received: from waste.org ([66.93.16.53]:33126 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759757AbXFGO6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 10:58:09 -0400
Date: Thu, 7 Jun 2007 09:57:44 -0500
From: Matt Mackall <mpm@selenic.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel 2.6.22-rc4 netconsole & syslogd bug
Message-ID: <20070607145744.GY11166@waste.org>
References: <Pine.LNX.4.64.0706061753190.3697@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706061753190.3697@p34.internal.lan>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 06:00:10PM -0400, Justin Piszcz wrote:
> 1. I use netconsole on almost all of my machines.
> 2. When I reboot one of them, it sends the kernel messages to the console
>    logging server.
> 3. However, whenever I reboot it spams the console and every xterm open
>    with the following:
> 
> Message from syslogd@p34 at Wed Jun  6 17:43:10 2007 ...
> p34 sdb3>
> 
> Message from syslogd@p34 at Wed Jun  6 17:43:10 2007 ...
> p34 sda3>
> 
> Message from syslogd@p34 at Wed Jun  6 17:43:10 2007 ...
> p34 sdb2>
> 
> Message from syslogd@p34 at Wed Jun  6 17:43:10 2007 ...
> p34 sda2>
> 
> Message from syslogd@p34 at Wed Jun  6 17:43:10 2007 ...
> p34 sdb1>
> 
> Message from syslogd@p34 at Wed Jun  6 17:43:10 2007 ...
> p34 sda1>
> 
> I also tried:
> 
> # Send p34 messages to their own file.
> @192.168.0.1        /var/log/p34.log

Your syslogd is probably getting confused by messages of the form
<foo> (and it rightly should be) and deciding they're maximal
priority. You probably have a separate clause somewhere that directs
all emergency messages to the console.

> Do I need to be running some sort of special netconsole server and send to 
> a different port to avoid this spam?

A lot of people simply run netcat.

-- 
Mathematics is the supreme nostalgia of our time.
