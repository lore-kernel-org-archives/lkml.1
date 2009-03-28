Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbZC1STV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbZC1STV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 14:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbZC1STE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 14:19:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:52849 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbZC1STB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 14:19:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lB4IMbwrkjK6mE8uJJSDPg/U3ouwDW23lCePvbcW/1M5+zPDlbjhJ4VY0x1J4qGmjB
         lmhBKnYxJzYTa0zd+wYhl1snV4xCNN+tEn5fBRcgDf+ST9WVeW7DG1IwNSu0Qlkjevjg
         pblwcPZmxQ/4HMQHVIYQNnBTkbSHlfVmZrXOk=
Message-ID: <49CE6A06.7080008@gmail.com>
Date: Sat, 28 Mar 2009 19:18:46 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, eteo@redhat.com,
       netdev@vger.kernel.org
Subject: Re: Dereferencing freed memory bugs
References: <a63d67fe0903240529v6a0e6b51pf67f8ad6dd6842c4@mail.gmail.com>
In-Reply-To: <a63d67fe0903240529v6a0e6b51pf67f8ad6dd6842c4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter pisze:
> I added a check to smatch (http://repo.or.cz/w/smatch.git/) to check
> for when we dereference
> freed memory.
> 
> (...)
> net/netfilter/nfnetlink_log.c +341 __nfulnl_flush(5) 'inst'
> (...)

I think it's a false positive. In __nfulnl_flush we expect that caller
already holds a reference to inst and it looks like all callers do it.


Marcin
