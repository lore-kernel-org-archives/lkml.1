Return-Path: <linux-kernel-owner+w=401wt.eu-S1752158AbZL1PCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbZL1PCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 10:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbZL1PCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 10:02:15 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49144 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbZL1PCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 10:02:12 -0500
To: Nitin Gupta <ngupta@vflare.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] [mmotm] Add notifiers for various swap events
From: Andi Kleen <andi@firstfloor.org>
References: <1261963200-7136-1-git-send-email-ngupta@vflare.org>
Date: Mon, 28 Dec 2009 16:02:10 +0100
In-Reply-To: <1261963200-7136-1-git-send-email-ngupta@vflare.org> (Nitin Gupta's message of "Mon, 28 Dec 2009 06:49:59 +0530")
Message-ID: <87eimf87m5.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nitin Gupta <ngupta@vflare.org> writes:

> Events:
>  - Swapon
>  - Swapoff
>  - When a swap slot is freed
>
> This is required for ramzswap module which implements RAM based block
> devices to be used as swap disks. These devices require a notification
> on these events to function properly.

The first question to ask is if compressed swap is worth
it. Do you have benchmark numbers showing it to be an improvement?
Are there cases where it is slower than uncompressed swap?


> Currently, I'm not sure if any of these event notifiers have any other
> users. However, adding ramzswap specific hooks instead of this generic
> approach resulted in a bad/hacky code.

If there's only a single user I think it's preferable to call
directly. That makes the code much easier to read and understand.
In the end notifiers are a form of code obfuscation.

The main use for notifiers would be if something is a optional
module, but that's not the case here.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
