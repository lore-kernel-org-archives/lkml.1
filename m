Return-Path: <linux-kernel-owner+w=401wt.eu-S1752369AbXE2X7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbXE2X7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 19:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbXE2X7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 19:59:09 -0400
Received: from gw.goop.org ([64.81.55.164]:59587 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbXE2X7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 19:59:07 -0400
Message-ID: <465CBE4B.9070009@goop.org>
Date: Tue, 29 May 2007 16:59:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: divy@chelsio.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2/7] cxgb3 - fix netpoll hanlder
References: <20070526225952.12115.30971.stgit@localhost.localdomain> <465B591B.1010507@garzik.org>
In-Reply-To: <465B591B.1010507@garzik.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
>>
>> +        t3_intr_handler(adapter, qs->rspq.polling) (0,
>> +                    (adapter->flags & USING_MSIX) ?
>> +                    (void *)qs : (void *)adapter);
>
> Remove needless casts to void*
The two branches of ?: need to have the same type; without the casts
they'd be "struct sge_qset" and "struct adapter".  Seems a bit cruddy to
have two types passed to one function depending on the MSI state, but
maybe that's OK.

    J
