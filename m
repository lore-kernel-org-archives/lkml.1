Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022Ab0ATCDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab0ATCDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 21:03:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755408Ab0ATCDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 21:03:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:53095 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881Ab0ATCDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 21:03:12 -0500
Message-ID: <4B566590.5030804@kernel.org>
Date: Wed, 20 Jan 2010 11:08:16 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net, andi@firstfloor.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 32/40] async: introduce workqueue based alternative implementation
References: <1263776272-382-1-git-send-email-tj@kernel.org>	<1263776272-382-33-git-send-email-tj@kernel.org>	<20100117220130.214d56f1@linux.intel.com>	<4B5420A3.3080200@kernel.org>	<20100118072523.2683cd59@linux.intel.com>	<4B55038D.3070106@kernel.org>	<4B550384.8030103@linux.intel.com>	<4B5565BE.4050406@kernel.org> <20100119063718.3f1f39cc@linux.intel.com> <4B564C23.1030708@kernel.org> <4B564ECC.9080707@linux.intel.com>
In-Reply-To: <4B564ECC.9080707@linux.intel.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Jan 2010 02:02:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/20/2010 09:31 AM, Arjan van de Ven wrote:
> On 1/19/2010 16:19, Tejun Heo wrote:
> 
>> Yeah, you can flush individual works from other works and wqs from
>> works running from different wqs.  What's not allowed is flushing the
>> wq a work is running on from the work.  Let's say if the flush code
>> can be modified to do so, would that change your opinion?
> 
> once you get "run in parallel, but have an API to wait on everyone
> who was scheduled before me"...  ... that'd be fine ;)

Cool, I'll give a shot at it then.  I think it would be better to
adapt the existing interface to the new uses if at all possible.

> but then you pretty much HAVE the cookie API, even if you don't have
> an actual cookie.  (just the cookie was an easy way to determine the
> "before me")

Yeap, but then again, whatever we do, all those synchronization
interfaces can be mapped onto each other eventually.

Thanks.

-- 
tejun
