Return-Path: <linux-kernel-owner+w=401wt.eu-S1757133AbYCTUIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133AbYCTUIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 16:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755068AbYCTUIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 16:08:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39296 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028AbYCTUII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 16:08:08 -0400
Message-ID: <47E2C420.5050008@zytor.com>
Date: Thu, 20 Mar 2008 13:08:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-netdev <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH] kernel: add byteorder macros with alignment fixups
References: <1206034454.17059.4.camel@brick>
In-Reply-To: <1206034454.17059.4.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> A common pattern in the kernel (especially networking) is:
> 
> le32_to_cpu(get_unaligned((__le32 *)x));
> 
> Repeat for various combinations of le/be and 64/32/16 bit.  Add
> a variant that operates on possibly unaligned pointers to
> byteorder/generic.h
> 

This should go in <asm-generic/*> since on some architectures this can 
be done significantly faster than the chained pattern, since you can get 
the reordering for "free".  Thus, architectures should be able to 
override the generic.

	-hpa
