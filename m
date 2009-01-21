Return-Path: <linux-kernel-owner+w=401wt.eu-S1762948AbZAUAQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762948AbZAUAQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 19:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757148AbZAUAQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 19:16:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37104
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756792AbZAUAQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 19:16:24 -0500
Date: Tue, 20 Jan 2009 16:16:26 -0800 (PST)
Message-Id: <20090120.161626.93641145.davem@davemloft.net>
To: jaswinder@kernel.org
Cc: mingo@elte.hu, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Confusion in usr/include/asm-generic/fcntl.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <1232496257.3123.19.camel@localhost.localdomain>
References: <1232496257.3123.19.camel@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaswinder Singh Rajput <jaswinder@kernel.org>
Date: Wed, 21 Jan 2009 05:34:17 +0530

> usr/include/asm-generic/fcntl.h is giving 2 'make headers_check' warnings:
>  usr/include/asm-generic/fcntl.h:127: leaks CONFIG_64BIT to userspace where it is not valid
>  usr/include/asm-generic/fcntl.h:149: leaks CONFIG_64BIT to userspace where it is not valid
> 
> usr/include/asm-generic/fcntl.h:
...
> #ifndef CONFIG_64BIT will always be true for userspace. So what is the use of #ifndef CONFIG_64BIT ?

Good catch.

This file needs to test for 64-bit'ness using some non-CONFIG_*
test.  And the standard built-in CPP macros which can be used
to check for that are different on every platform.
