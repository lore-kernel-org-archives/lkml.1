Return-Path: <linux-kernel-owner+w=401wt.eu-S1751258AbZL1KVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258AbZL1KVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbZL1KVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:21:33 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:65076 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbZL1KVc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:21:32 -0500
MIME-Version: 1.0
In-Reply-To: <84144f020912272213u38389b79i25a0f50855d55673@mail.gmail.com>
References: <1261963200-7136-1-git-send-email-ngupta@vflare.org>
	 <84144f020912272213u38389b79i25a0f50855d55673@mail.gmail.com>
Date: Mon, 28 Dec 2009 15:51:31 +0530
Message-ID: <d760cf2d0912280221s7d24fac6u571243fdd2c71862@mail.gmail.com>
Subject: Re: [PATCH 1/2] [mmotm] Add notifiers for various swap events
From: Nitin Gupta <ngupta@vflare.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 28, 2009 at 11:43 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On Mon, Dec 28, 2009 at 3:19 AM, Nitin Gupta <ngupta@vflare.org> wrote:
>> Events:
>>  - Swapon
>>  - Swapoff
>>  - When a swap slot is freed

<snip>

> This looks good to me. Hugh? Nitin, does this patch cause any
> performance hit for the !CONFIG_RAMZSWAP case?
>

I have not yet collected any data to check overhead in !RAMZSWAP
case but an empty notifier chain is essentially equivalent to:

rcu_read_lock()
        nb = rcu_dereference(*nl);
rcu_read_unlock()

This should not cause any performance problem. Anyway, I will
try to come up with some numbers to confirm this.

Thanks for looking into this.
Nitin
