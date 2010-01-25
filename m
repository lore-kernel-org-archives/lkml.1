Return-Path: <linux-kernel-owner+w=401wt.eu-S1754111Ab0AYPVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab0AYPVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 10:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858Ab0AYPV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 10:21:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:43045 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924Ab0AYPV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 10:21:26 -0500
Message-ID: <4B5DB7E5.3070907@kernel.org>
Date: Tue, 26 Jan 2010 00:25:25 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       Steve French <sfrench@samba.org>
Subject: Re: [PATCH UPDATED 38/40] cifs: use workqueue instead of slow-work
References: <1263776272-382-1-git-send-email-tj@kernel.org>	<1263776272-382-39-git-send-email-tj@kernel.org>	<20100119072000.247ac894@tlielax.poochiereds.net>	<4B564B12.7020909@kernel.org>	<20100119195641.7b6a17e4@tlielax.poochiereds.net>	<4B565B26.3060709@kernel.org>	<4B59889D.7050903@kernel.org>	<20100122064528.0223d708@tlielax.poochiereds.net>	<4B5C03EE.3000007@kernel.org> <20100124071334.0f12276e@tlielax.poochiereds.net>
In-Reply-To: <20100124071334.0f12276e@tlielax.poochiereds.net>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 25 Jan 2010 15:19:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/24/2010 09:13 PM, Jeff Layton wrote:
>> Are you sure it needs to be changed?
>>
> 
> I'm pretty sure we do. This flag only gets set to true if there's a
> reconnection event. If there is one, then any oplock break queued up
> before that happened is now invalid and shouldn't be sent.
> 
> It's a fairly minor point however. Even if we send the oplock break,
> it's very unlikely to be treated as valid by the server as I don't
> think the file would have a chance to be reopened prior to that.
> 
> If this is the way that the code works now, then let's go ahead with
> your version and I'll plan to queue up a separate patch to change that
> behavior after your changes go in.

Yeap, that sounds good to me or I just can queue a separate patch to
do that along with this one so that you don't have to remember
queueing it later.

Thanks.

-- 
tejun
