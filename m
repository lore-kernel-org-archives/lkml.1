Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbYILFtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbYILFtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 01:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbYILFtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 01:49:10 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:40998 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbYILFtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 01:49:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ABkQsy1RlZ313YTK2GByDmTzdDa7mEHKhTYbxq6SS0UB9usIgLw/9Z/cHtAVx7fQ8W
         sW2cmqb9DNSoMzm5D29Q7oDUUsXqe8ytAmfYtgHYC5//lvkf0BfsnNc08WVEcskx+mkN
         ihCA1ua5VVinHLnoA/R/vrfxSNwtdEYmRC+9U=
Message-ID: <19f34abd0809112249j7d289caese42cfc019b4cac2c@mail.gmail.com>
Date: Fri, 12 Sep 2008 07:49:08 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "David Wagner" <daw-news@cs.berkeley.edu>
Subject: Re: [PATCH] netlink: fix overrun in attribute iteration
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <gacp0q$drj$1@taverner.cs.berkeley.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080911205933.GA20032@localhost.localdomain>
	 <gacp0q$drj$1@taverner.cs.berkeley.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 5:51 AM, David Wagner <daw@cs.berkeley.edu> wrote:
> Vegard Nossum  wrote:
>>  /**
>>   * nla_ok - check if the netlink attribute fits into the remaining bytes
>>   * @nla: netlink attribute
>>   * @remaining: number of bytes remaining in attribute stream
>>   */
>>  static inline int nla_ok(const struct nlattr *nla, int remaining)
>>  {
>>          return remaining >= sizeof(*nla) &&
>>                 nla->nla_len >= sizeof(*nla) &&
>>                 nla->nla_len <= remaining;
>>  }
>
> If 'remaining' had been declared to be of type size_t, this would
> not have happened.

Hm. Yes, it would!

The problem here is that "remaining" can legitimately contain negative
values (see the pointer advancement in nla_next()). And size_t can't
hold negative values.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
