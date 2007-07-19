Return-Path: <linux-kernel-owner+w=401wt.eu-S965753AbXGSORv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965753AbXGSORv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939254AbXGSOPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 10:15:06 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43752 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939243AbXGSOPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 10:15:00 -0400
Message-ID: <469F71E7.4050200@bull.net>
Date: Thu, 19 Jul 2007 16:15:03 +0200
From: Zoltan Menyhart <Zoltan.Menyhart@bull.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.3) Gecko/20040913
X-Accept-Language: en-us, en, fr, hu
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, tony.luck@intel.com, nickpiggin@yahoo.com.au,
       mike@stroyan.net, dmosberger@gmail.com, y-goto@jp.fujitsu.com
Subject: Re: [BUGFIX]{PATCH] flush icache on ia64 take2
References: <20070706112901.16bb5f8a.kamezawa.hiroyu@jp.fujitsu.com>	<20070719155632.7dbfb110.kamezawa.hiroyu@jp.fujitsu.com>	<469F5372.7010703@bull.net> <20070719220118.73f40346.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070719220118.73f40346.kamezawa.hiroyu@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 19/07/2007 16:19:30,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 19/07/2007 16:19:33,
	Serialize complete at 19/07/2007 16:19:33
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:

> But is it too costly that flushing icache page only if a page is newly
> installed into the system (PG_arch1) && it is mapped as executable ?

Well it was a bit long time ago, I measured on a Tiger box with
CPUs of 1.3 GHz:

Flushing a page of 64 Kbytes, with modified data in D-cache
(it's slower that not having modified data in the D-cache):

13.1 ... 14.7 usec.

You may have quicker machines, but having more CPUs or a NUMA architecture
can slow it down considerably:
- more CPUs have to agree that that's the moment to carry out a flush
- NUMA adds delay

We may have, say 1 Gbyte / sec local i/o activity (using some RAIDs).
Assume a few % of this 1 Gbyte is the program execution, or program swap in.
It gives some hundreds of new exec pages / sec =>
some msec-s can be lost each sec.

I can agree that it should not be a big deal :-)

> I don't want to leak this (stupid) corner case to the file system layer.
> Hmm...can't we do clever flushing (like your idea) in VM layer ?

As the VM layer is designed to be independent of the page read in stuff...

Thanks,

Zoltan
