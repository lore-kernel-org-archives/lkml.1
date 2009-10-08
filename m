Return-Path: <linux-kernel-owner+w=401wt.eu-S1759946AbZJHS7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759946AbZJHS7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 14:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759933AbZJHS7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 14:59:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37945 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759931AbZJHS7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 14:59:47 -0400
Message-ID: <4ACE364E.8090000@zytor.com>
Date: Thu, 08 Oct 2009 11:58:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Jan Beulich <JBeulich@novell.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: don't leak kernel register values to 32-bit	processes
References: <4AC34D73020000780001744A@vpn.id2.novell.com> <20091007094248.GA1425@ucw.cz>
In-Reply-To: <20091007094248.GA1425@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2009 02:44 AM, Pavel Machek wrote:
> Hi!
> 
>> While 32-bit processes can't directly access R8...R15, they can gain
>> access to these registers by temporarily switching themselves into
>> 64-bit mode. Therefore, registers not preserved anyway by called C
>> functions (i.e. R8...R11) must be cleared prior to returning to user
>> mode.
> 
> How can userspace "temporarily switch itself" to 64bit mode?
> 
> Such ability would lead to very interesting behaviour on 32-bit
> kernel, I'd say...

You can only do so with a 64-bit kernel, but on a 64-bit kernel you can
do it by executing a far jump to segment USER_CS (0x33).

	-hpa

