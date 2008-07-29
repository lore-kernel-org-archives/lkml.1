Return-Path: <linux-kernel-owner+w=401wt.eu-S1755740AbYG2G3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbYG2G3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 02:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbYG2G3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 02:29:22 -0400
Received: from gw.goop.org ([64.81.55.164]:42948 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbYG2G3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 02:29:22 -0400
Message-ID: <488EB8BE.8050806@goop.org>
Date: Mon, 28 Jul 2008 23:29:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: Is there still value in having a special tlb flush IPI vector?
References: <488E534F.2030204@goop.org> <488E5455.6010901@goop.org> <20080729021215.GG30344@one.firstfloor.org>
In-Reply-To: <20080729021215.GG30344@one.firstfloor.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>>> Now that normal smp_function_call is no longer an enormous bottleneck, 
>>>       
>
> Hmm? It still uses a global lock at least as of current git tree.

Yes, but it's only held briefly to put things onto the list.  It doesn't 
get held over the whole IPI transaction as the old smp_call_function 
did, and the tlb flush code still does.  RCU is used to manage the list 
walk and freeing, so there's no long-held locks there either.

    J
