Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbXEXX7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbXEXX7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 19:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbXEXX7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 19:59:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37640
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750709AbXEXX7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 19:59:44 -0400
Date: Thu, 24 May 2007 16:59:47 -0700 (PDT)
Message-Id: <20070524.165947.09931811.davem@davemloft.net>
To: vvs@sw.ru
Cc: dada1@cosmosbay.com, netdev@vger.kernel.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH netdev] "wrong timeout value" in sk_wait_data() v2
From: David Miller <davem@davemloft.net>
In-Reply-To: <46552142.4090801@sw.ru>
References: <465512EB.4000808@sw.ru>
	<46551635.30809@cosmosbay.com>
	<46552142.4090801@sw.ru>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasily Averin <vvs@sw.ru>
Date: Thu, 24 May 2007 09:23:14 +0400

> sys_setsockopt() do not check properly timeout values for
> SO_RCVTIMEO/SO_SNDTIMEO, for example it's possible to set negative timeout
> values. POSIX do not defines behaviour for sys_setsockopt in case negative
> timeouts, but requires that setsockopt() shall fail with -EDOM if the send and
> receive timeout values are too big to fit into the timeout fields in the socket
> structure.
> In current implementation negative timeout can lead to error messages like
> "schedule_timeout: wrong timeout value".
> 
> Proposed patch:
> - checks tv_usec and returns -EDOM if it is wrong
> - do not allows to set negative timeout values (sets 0 instead) and outputs
> ratelimited information message about such attempts.
> 
> Signed-Off-By:	Vasily Averin <vvs@sw.ru>

Thank you for this bug fix, patch applied.
