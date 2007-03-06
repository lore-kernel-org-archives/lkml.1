Return-Path: <linux-kernel-owner+w=401wt.eu-S965158AbXCFPQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965158AbXCFPQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 10:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965174AbXCFPQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 10:16:28 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:40195 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965158AbXCFPQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 10:16:27 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: "Vladimir B. Savkin" <master@sectorb.msk.ru>
Subject: Re: Packet timestamps (was: Re: Network performance degradation from 2.6.11.12 to 2.6.16.20)
Date: Tue, 6 Mar 2007 16:16:24 +0100
User-Agent: KMail/1.9.5
Cc: netdev@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       David Miller <davem@davemloft.net>, hawk@diku.dk,
       harry@atmos.washington.edu, linux-kernel@vger.kernel.org,
       Rick Jones <rick.jones2@hp.com>
References: <200609181850.22851.ak@suse.de> <200703061538.45049.dada1@cosmosbay.com> <20070306144315.GA9036@tentacle.sectorb.msk.ru>
In-Reply-To: <20070306144315.GA9036@tentacle.sectorb.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703061616.24959.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 March 2007 15:43, Vladimir B. Savkin wrote:
> On Tue, Mar 06, 2007 at 03:38:44PM +0100, Eric Dumazet wrote:
> > 2) "accurate_timestamps" is misleading.
> > 	Should be "disable_timestamps"
>
> Not, if default is 1, as in my patch.

Yes I saw this. I should write more words next time :)

Full explanation:
----------------------

If your tunable is named "accurate_timestamps" then a 0 value would mean :

Use a low precision timestamp (based on xtime for example) instead of a full 
resolution...

This is not what your patch does (while it could do that, but beware that 
net-2.6.22 includes now a ktime_t timestamping)

So :
------

It would be better to name the tunable "disable_timestamps", default 0 of 
course.... 
It would better describe what your patch is actually doing : Even if a tcpdump 
is running (so asking for timestamps), it wont have them because the sysctl 
disabled them.

Thank you

