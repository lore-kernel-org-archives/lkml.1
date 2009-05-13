Return-Path: <linux-kernel-owner+w=401wt.eu-S1760690AbZEMQbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760690AbZEMQbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 12:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756045AbZEMQbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 12:31:33 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:28265 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbZEMQbc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 12:31:32 -0400
MIME-Version: 1.0
In-Reply-To: <5083.1242215914@redhat.com>
References: <alpine.DEB.2.00.0905100336130.27219@ubuntu-desktop>
	 <alpine.DEB.2.00.0905101959070.2913@ubuntu-desktop>
	 <5083.1242215914@redhat.com>
Date: Wed, 13 May 2009 09:31:33 -0700
Message-ID: <a24804730905130931g6acbe0b1t6a6656d51c937624@mail.gmail.com>
Subject: Re: [PATCH v2] use round_jiffies() for slow work thread pool's 5 
	second cull timer
From: Chris Peterson <cpeterso@cpeterso.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This is a revised patch to round the slow work queue's 5 second timers to
>> whole seconds with round_jiffies().
>
> Why?  Your patch description doesn't say.
>

oops, good question. round_jiffies is useful for timers for which the
exact time they fire does not matter too much, as long as they fire
approximately every X seconds.

By rounding non-time-critical timers to whole seconds, all such timers
will be batched up to fire at the same time, rather than at various
times spread out. The goal of this is to have the CPU wake up less,
which saves power.

chris
