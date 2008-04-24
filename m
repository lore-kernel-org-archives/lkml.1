Return-Path: <linux-kernel-owner+w=401wt.eu-S1762010AbYDXP4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762010AbYDXP4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759753AbYDXPzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:55:46 -0400
Received: from brmea-mail-2.Sun.COM ([192.18.98.43]:49295 "EHLO
	brmea-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759398AbYDXPzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:55:40 -0400
Date: Thu, 24 Apr 2008 11:53:14 -0400
From: David Collier-Brown <davecb@sun.com>
Subject: Re: [RFC][PATCH 0/3] Skip I/O merges when disabled
In-reply-to: <20080424150425.GD12774@kernel.dk>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: davecb@sun.com
Message-id: <4810ACEA.5070401@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
X-Accept-Language: en-us, en
References: <480F8936.5030406@hp.com> <87ve27gz4u.fsf@basil.nowhere.org>
 <67E36C56-E149-4C87-8788-05BA43C1C2AD@kernel.dk>
 <4810961A.4000104@firstfloor.org> <20080424150425.GD12774@kernel.dk>
User-Agent: Mozilla/5.0 (X11; U; SunOS sun4u; en-US; rv:1.7) Gecko/20041221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Thu, Apr 24 2008, Andi Kleen wrote:
> 
>>>Not a good idea IMHO, it's much better with an explicit setting. That
>>>way you don't introduce indeterministic behavior.
>>
>>So you would be deterministically slower.
> 
> 
> Yes, absolutely. Think about the case for a second - the potential gain is in
> fractions of a percent basically, the potential loss however is HUGE.
> There's absolutely no way on earth I'd ever make this dynamic.

  If this is intended for databases, it might be backwards (;-)) 

  The commercial unix "forcedirectio" option that Oracle and other
database vendors usually ask for turns out to be a benefit
in large sequential data transfers, because it does two things:

1) transfers directly between user address space and disk, avoiding buffering, and
2) allows enthusiastic coalescence of synchronous writes

  Is this intended for DBMSs, or for something esle?

--dave 
-- 
David Collier-Brown            | Always do right. This will gratify
Sun Microsystems, Toronto      | some people and astonish the rest
davecb@sun.com                 |                      -- Mark Twain
(905) 943-1983, cell: (647) 833-9377, (800) 555-9786 x56583
bridge: (877) 385-4099 code: 506 9191#
