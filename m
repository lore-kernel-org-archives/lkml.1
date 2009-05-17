Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbZEQHvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbZEQHvJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 03:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbZEQHuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 03:50:55 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:62261 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbZEQHuy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 03:50:54 -0400
MIME-Version: 1.0
In-Reply-To: <20090516230350.ec4fb487.akpm@linux-foundation.org>
References: <a24804730905160036j2720c557o347cec1513df9c4a@mail.gmail.com>
	 <20090516230350.ec4fb487.akpm@linux-foundation.org>
Date: Sun, 17 May 2009 00:50:55 -0700
Message-ID: <a24804730905170050m16bfb81cj6c9ee4c99ac9d08f@mail.gmail.com>
Subject: Re: [RFC] mod_timer() helper functions?
From: Chris Peterson <cpeterso@cpeterso.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Reviewing the kernel's nearly one-thousand calls to mod_timer(), there
>> are three basic patterns:
>>
>>  * multi-second timeouts
>>  * millisecond timeouts
>>  * +1 jiffie ASAP events
>>

Is there a functional difference between the following "expire this
timer ASAP" statements?

mod_timer(timer, jiffies + 1); /* 48 uses */
mod_timer(timer, jiffies); /* 44 uses */
mod_timer(timer, jiffies - 1); /* 6 uses */


chris
