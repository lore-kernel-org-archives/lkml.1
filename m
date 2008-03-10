Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbYCJR0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbYCJR0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 13:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbYCJR0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 13:26:36 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:53580 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751229AbYCJR0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 13:26:35 -0400
Message-ID: <47D56F4A.5070208@steeleye.com>
Date: Mon, 10 Mar 2008 13:26:34 -0400
From: Paul Clements <paul.clements@steeleye.com>
User-Agent: Swiftdove 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       nbd-general@lists.sourceforge.net,
       Laurent Vivier <Laurent.Vivier@bull.net>
Subject: Re: [PATCH 1/1] NBD: allow nbd to be used locally
References: <47D468F0.8000506@steeleye.com> <20080310102917.GA27751@elf.ucw.cz>
In-Reply-To: <20080310102917.GA27751@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:

>> This patch allows a Network Block Device to be mounted locally (nbd-client 
>> to nbd-server over 127.0.0.1).
>>
>> It creates a kthread to avoid the deadlock described in NBD tools 
>> documentation. So, if nbd-client hangs waiting for pages, the kblockd 
>> thread can continue its work and free pages.
> 
> What happens if your new kthread blocks on memory allocation?

Well, we expect that. The reason for the new thread is so that it hangs, 
rather than kblockd hanging (which on a UP system brings all I/O to a 
halt). As long as kblockd can continue making progress, we eventually 
free up memory and then NBD can finish its requests, too.

--
Paul
