Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab0BOHCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 02:02:30 -0500
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:45734 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751465Ab0BOHC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 02:02:29 -0500
Date: Mon, 15 Feb 2010 09:02:19 +0200
From: Jouni Malinen <j@w1.fi>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michael Neuling <mikey@neuling.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.33-rc8 breaks UML with Restrict initial stack space
 expansion to rlimit
Message-ID: <20100215070219.GB14412@jm.kir.nu>
References: <20100214164023.GA2726@jm.kir.nu>
 <9296.1266185019@neuling.org>
 <20100215113751.7275.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100215113751.7275.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 11:38:52AM +0900, KOSAKI Motohiro wrote:
> Wow. It seems very strange. Usually stack overflow makes SIGSEGV, not SIGKILL.
> plus, In my environment (x86_64 non-uml), mount command doesn't use
> the stack so much.

The SIGKILL part is the odd one, I would assume.. It looks like about
half of the commands are failing with SIGKILL even with ulimit -s 8192
and the ulimit -s value did not really change the failure rate that
much if at all. SIGSEGV starts showing up only after having limited
ulimit -s to quite samll number (see my previous email).

> % /usr/bin/time --format="mem %M" ls
> /usr/bin/time --format="mem %M" ls
> GPATH      INSTALL  README       configure    fdisk          lib      misc-utils   schedutils
> mem 3232

mem 3296
on my UML setup

> % sudo /usr/bin/time --format="mem %M"  mount -a
> sudo /usr/bin/time --format="mem %M"  mount -a
> mem 2992

mem 2928

-- 
Jouni Malinen                                            PGP id EFC895FA
