Return-Path: <linux-kernel-owner+w=401wt.eu-S965404AbXDHBh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965404AbXDHBh6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 21:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966020AbXDHBh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 21:37:58 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:51592 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965404AbXDHBh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 21:37:57 -0400
Date: Sat, 7 Apr 2007 18:39:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Cc: aeb@cwi.nl, linux-kernel@vger.kernel.org
Subject: Re: [RFC] partitions: CONFIG_BLK_DEV_MD and modular RAID support
Message-Id: <20070407183950.1199c945.randy.dunlap@oracle.com>
In-Reply-To: <alpine.DEB.0.83.0704071836060.19488@sigma.j-a-k-j.com>
References: <alpine.DEB.0.83.0704071836060.19488@sigma.j-a-k-j.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Apr 2007 18:47:20 -0400 (EDT) John Anthony Kazos Jr. wrote:

> (Linux v2.6.20.6.)
> 
> The function md_autodetect_dev is defined in drivers/md/md.c. Its 
> declaration is on line 1443, outside of conditionals. However, both its 
> use on line 1455 and its definition on line 5600 are inside "#ifndef 
> MODULE" conditionals. So it seems obvious that the declaration should be 
> inside conditionals as well.
> 
> However, this function is separately declared and used in 
> fs/partitions/check.c but not inside the same conditional, which means if 
> md.c is compiled as a module, check.c will be referencing an undefined 
> symbol.

I don't get a build error when BLK_DEV_MD=m.  Do you?

Do you want to determine why there is no build error?
Hint:  look at include/linux/autoconf.h.

> Should the conditionals around md_autodetect_dev be changed to make sure 
> CONFIG_BLK_DEV_MD=y, or does the function need to be extracted from md.c 
> so it can be used by check.c in any case?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
