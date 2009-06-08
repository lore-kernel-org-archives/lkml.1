Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbZFHWzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbZFHWzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 18:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbZFHWz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 18:55:29 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53403 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbZFHWz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 18:55:28 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A2D96C5.2080604@s5r6.in-berlin.de>
Date: Tue, 09 Jun 2009 00:55:01 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090411 SeaMonkey/1.1.16
MIME-Version: 1.0
To: David VomLehn <dvomlehn@cisco.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-usb@vger.kernel.org, greg@kroah.com, linux-scsi@vger.kernel.org,
       netdev@vger.kernel.org, arjan@infradead.org
Subject: Re: [PATCH 7/7] initdev:kernel:Await block device discovery
References: <20090606023416.GA5798@cuplxvomd02.corp.sa.net> <4A2A3F36.4070408@s5r6.in-berlin.de> <20090608223019.GC22222@cuplxvomd02.corp.sa.net>
In-Reply-To: <20090608223019.GC22222@cuplxvomd02.corp.sa.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David VomLehn wrote:
> On Sat, Jun 06, 2009 at 06:04:38AM -0400, Stefan Richter wrote:
>> 1.)  It depends on the rootdelay so big that it is guaranteed that one 
>> or more initdev_found() have been called before prepare_namespace()'s 
>> ssleep(root_delay) is over.
...
> I think you misunderstood.  Buses are enumerated before this code is
> reached and thus initdev_found() has already been called for all attached
> block devices.
...
> I would appreciate it if you could take a closer look at the locations where
> initdev_found() and initdev_probe_done() are called and see if you still
> think there is a problem.

I obviously need to do that.

However, one issue remains:  If somebody wants to use your API for 
another bus, he needs to know at which point he can successfully use it, 
and after what point (or context) it cannot, even must not, be used 
anymore.  This isn't documented --- or is it?

(By 'buses are enumerated before...' you surely mean only the buses for 
which you implemented this API usage already.)
-- 
Stefan Richter
-=====-==--= -==- -=--=
http://arcgraph.de/sr/
