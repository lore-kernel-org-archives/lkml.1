Return-Path: <linux-kernel-owner+w=401wt.eu-S1764263AbXGLBFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764263AbXGLBFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 21:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756532AbXGLBFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 21:05:43 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:48018 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbXGLBFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 21:05:41 -0400
Date: Thu, 12 Jul 2007 10:06:17 +0900 (JST)
Message-Id: <20070712.100617.14203407.yoshfuji@linux-ipv6.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, htejun@gmail.com, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH 24/61] sysfs: make sysfs_put() ignore NULL sd
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <20070711235529.GA7485@suse.de>
References: <11841968512510-git-send-email-gregkh@suse.de>
	<20070712.085047.37780825.yoshfuji@linux-ipv6.org>
	<20070711235529.GA7485@suse.de>
Organization: USAGI/WIDE Project
X-URL: http://www.yoshifuji.org/%7Ehideaki/
X-Fingerprint: 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
X-PGP-Key-URL: http://www.yoshifuji.org/%7Ehideaki/hideaki@yoshifuji.org.asc
X-Face: "5$Al-.M>NJ%a'@hhZdQm:."qn~PA^gq4o*>iCFToq*bAi#4FRtx}enhuQKz7fNqQz\BYU]
 $~O_5m-9'}MIs`XGwIEscw;e5b>n"B_?j/AkL~i/MEa<!5P`&C$@oP>ZBLP
X-Mailer: Mew version 3.3 on Emacs 20.7 / Mule 4.1 (AOI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <20070711235529.GA7485@suse.de> (at Wed, 11 Jul 2007 16:55:29 -0700), Greg KH <gregkh@suse.de> says:

> On Thu, Jul 12, 2007 at 08:50:47AM +0900, YOSHIFUJI Hideaki / ?$B5HF#1QL@ wrote:
> > In article <11841968512510-git-send-email-gregkh@suse.de> (at Wed, 11 Jul 2007 16:31:43 -0700), Greg Kroah-Hartman <gregkh@suse.de> says:
> > 
> > > Make sysfs_put() ignore NULL sd instead of oopsing.
> > 
> > I do not think this is a good idea; it is non-sense (and rather a bug)
> > to call "put" with NULL argument in general.
> 
> It's better than having to check it all the time in the caller :)

How many callers do we have that will get benefit from this change?

Well, the change will hide the bug. It seems all callers in fs/sysfs
already assume that the argument is NOT NULL, and it is a bug to call
sysfs_put() with NULL; the function should be used to "put" something
you "have" (non-NULL). If it is called with NULL, I would say, we
should BUG here to detect the logical bug.

--yoshfuji
