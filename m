Return-Path: <linux-kernel-owner+w=401wt.eu-S933647AbXGMNpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647AbXGMNpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 09:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757246AbXGMNpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 09:45:17 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:56855 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100AbXGMNpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 09:45:15 -0400
Message-ID: <46978150.80909@bx.jp.nec.com>
Date: Fri, 13 Jul 2007 22:42:40 +0900
From: KII Keiichi <k-keiichi@bx.jp.nec.com>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, Netdev <netdev@vger.kernel.org>,
       Joel Becker <joel.becker@oracle.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2 -mm 3/9] netconsole: Simplify boot/module option setup
 logic
References: <20070710091920.23907.96483.sendpatchset@cselinux1.cse.iitk.ac.in> <20070710091936.23907.68970.sendpatchset@cselinux1.cse.iitk.ac.in>
In-Reply-To: <20070710091936.23907.68970.sendpatchset@cselinux1.cse.iitk.ac.in>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Satyam,

> From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> 
> [3/9] netconsole: Simplify boot/module option setup logic
> 
> Presently, for built-in netconsole:
> 
> __setup(..., option_setup) ensures that the option_setup() function is
> called at boot-time from obsolete_checksetup() with the string matching
> "netconsole=" passed to it from the kernel's command line. We call the
> netpoll_parse_options() from in there, and populate the netpoll struct
> with the passed values. Then, when init_netconsole() is called during the
> initcall phase, strlen(config) fails, thus skipping option_setup().
> 
> For modular netconsole:
> 
> module_param_string() ensures that the string corresponding to the
> "netconsole" module parameter passed from the modprobe command line is
> copied into the "config" static variable. This time, when the module is
> being initialized, strlen(config) is true and so option_setup() is called
> on "config" from init_netconsole() and the input string is parsed and the
> netpoll struct populated.
> 
> Hence, quite different things happen in the copying and parsing of the
> passed netpoll parameters for the modular / built-in cases. This patch
> makes both of them similar by doing exactly the equivalent of a
> module_param_string() in option_setup() also -- just copying the param
> string passed from the kernel command line into the "config" static
> variable. So, init_netconsole() parses (using netpoll_parse_options())
> it in both the cases, and makes the logic somewhat simpler.
> 
> Now, option_setup() is only ever called / used for the built-in case,
> so we put it inside a #ifndef MODULE, otherwise gcc will complain about
> option_setup() being "defined but not used".
> 
> Also, the "configured" variable is redundant with this patch and so removed.
> 
> Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> Cc: Keiichi Kii <k-keiichi@bx.jp.nec.com>
> 
Signed-off-by: Keiichi Kii <k-keiichi@bx.jp.nec.com>

Thanks
-- 
Keiichi KII
NEC Corporation OSS Platform Development Division
E-mail: k-keiichi@bx.jp.nec.com 
