Return-Path: <linux-kernel-owner+w=401wt.eu-S1758206AbYGFRWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206AbYGFRWX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756874AbYGFRVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:21:53 -0400
Received: from gw.goop.org ([64.81.55.164]:40423 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756814AbYGFRVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:21:52 -0400
Message-ID: <4870FF28.80904@goop.org>
Date: Sun, 06 Jul 2008 10:21:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] generic ipi function calls: wait on alloc failure fallback
References: <4870DBB6.30107@goop.org> <4870ECBA.7050901@goop.org>
In-Reply-To: <4870ECBA.7050901@goop.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> When a GFP_ATOMIC allocation fails, smp_call_function_mask falls back
> to allocating the data on the stack and converting it to a waiting call.
>
> Make sure we actually wait in this case. 

Unfortunately this doesn't solve my crash, though it may account for 
some of them.

The oops I'm looking at at the moment is a NULL pointer on ->next of the 
rcu list in generic_smp_call_function_interrupt()...

    J
