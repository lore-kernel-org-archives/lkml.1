Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbYGYSOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbYGYSOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 14:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbYGYSOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 14:14:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57747 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbYGYSOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 14:14:34 -0400
Message-ID: <488A17EC.2000107@zytor.com>
Date: Fri, 25 Jul 2008 14:14:04 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] byteorder: force in-place endian conversion to always
 evaluate args
References: <1217003621.5971.4.camel@brick>
In-Reply-To: <1217003621.5971.4.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> David Miller reported breakage in ide when the in-place byteorder helpers
> were used as the macros do not always evaluate their args which led to
> an infinite loop.
> 
> Just make them functions to ensure they always do so.

> -#define __cpu_to_be64s(x) do {} while (0)

For what it's worth, the way to write a macro like this:

#define __cpu_to_be64s(x) ((void)(x))

	-hpa
