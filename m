Return-Path: <linux-kernel-owner+w=401wt.eu-S932117AbXDLQmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117AbXDLQmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 12:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964934AbXDLQmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 12:42:54 -0400
Received: from gw1a.telemetry-investments.com ([64.20.161.180]:57531 "EHLO
	sv1.telemetry-investments.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932117AbXDLQmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 12:42:52 -0400
Date: Thu, 12 Apr 2007 12:42:51 -0400
From: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Christopher S. Aker" <caker@theshore.net>, linux-kernel@vger.kernel.org
Subject: Re: [Feature Request?] Inline compression of process core dumps
Message-ID: <20070412164251.GC11736@ti88.telemetry-investments.com>
Mail-Followup-To: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	"Christopher S. Aker" <caker@theshore.net>,
	linux-kernel@vger.kernel.org
References: <461E55C6.1030905@theshore.net> <20070412172845.58bfeff5@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412172845.58bfeff5@the-village.bc.nu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 05:28:45PM +0100, Alan Cox wrote:
> > There are userspace solutions to this problem:  allowing the 
> > uncompressed core dump to spin out to disk and then coming in afterwards 
> > and doing the compression, or maybe even a compressed filesystem where 
> > the core dumps land, but I just thought I'd throw this out there since 
> > it seems it would be a useful feature :)
> 
> Indeed. So useful that in current kernels you can set the core dump path
> to be
> 
> 	"|application"
> 
> and it will call out to the helper. Take care with the helper as it will
> get run for setuid apps, roots core dumps etc.

The current functionality doesn't parse command line arguments into argv,
nor provide the % variable replacements in the environment, so it is
somewhat less useful than it could be.  I supposed that parsing the command
line introduces potential problems with file names that include whitespace.
It would probably be better to split the command-line on whitespace, then
replace variables in the argv[]?

fs/exec.c:
1507         if (corename[0] == '|') {
1508                 /* SIGPIPE can happen, but it's just never processed */
1509                 if(call_usermodehelper_pipe(corename+1, NULL, NULL, &file)) {
1510                         printk(KERN_INFO "Core dump to %s pipe failed\n",
1511                                corename);
1512                         goto fail_unlock;
1513                 }
1514                 ispipe = 1;
1515         } else
1516                 file = filp_open(corename,
1517                                  O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
1518                                  0600);


Regards,

	Bill Rugolsky
