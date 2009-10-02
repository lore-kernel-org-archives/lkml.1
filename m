Return-Path: <linux-kernel-owner+w=401wt.eu-S1757674AbZJBMqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674AbZJBMqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 08:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756825AbZJBMqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 08:46:48 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:48126 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576AbZJBMqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 08:46:47 -0400
Message-ID: <4AC5F5FB.9050202@s5r6.in-berlin.de>
Date: Fri, 02 Oct 2009 14:45:47 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.22) Gecko/20090605 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: David Howells <dhowells@redhat.com>, jeff@garzik.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       arjan@linux.intel.com
Subject: Re: [RFC PATCHSET] workqueue: implement concurrency managed workqueue
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <9942.1254401629@redhat.com> <4AC5E7BA.5060700@kernel.org>
In-Reply-To: <4AC5E7BA.5060700@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> David Howells wrote:
>> Sounds interesting as a replacement for slow-work.  Some thoughts for you:
>> 
>> The most important features of slow-work are:
>> 
>>  (1) Work items are not re-entered whilst they are executing.
>> 
>>  (2) The slow-work facility keeps references on its work items by asking the
>>      client to get and put on the client's refcount.
>> 
>>  (3) The slow-work facility can create a lot more threads than the number of
>>      CPUs on a system, and the system doesn't grind to a halt if they're all
>>      taken up with long term I/O (performing several mkdirs for example).
>> 
>> I think you have (1) and (3) covered, but I'm unsure about (2).
> 
> Given that slow-work isn't being used too extensively yet, I was
> thinking whether that part could be pushed down to the caller.  Or, we
> can also wrap work and export an interface which supports the get/put
> reference.

BTW, not only slow-work users need reference counting, many existing
regular workqueue users could use it as well.  (Well, I guess I stated
the obvious.)  Currently we have local wrappers for that like these ones:
http://lxr.linux.no/#linux+v2.6.31/drivers/firewire/core-card.c#L212
http://lxr.linux.no/#linux+v2.6.31/drivers/firewire/sbp2.c#L838
-- 
Stefan Richter
-=====-==--= =-=- ---=-
http://arcgraph.de/sr/
