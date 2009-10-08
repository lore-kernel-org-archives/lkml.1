Return-Path: <linux-kernel-owner+w=401wt.eu-S1757716AbZJHLmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716AbZJHLmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 07:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757594AbZJHLmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 07:42:05 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:51324 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576AbZJHLmE convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;4:1>);
	Thu, 8 Oct 2009 07:42:04 -0400
Message-Id: <4ACDEC070200007800018B57@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 08 Oct 2009 12:41:27 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Pavel Machek" <pavel@ucw.cz>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
       <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: don't leak kernel register values to
	 32-bit processes
References: <4AC34D73020000780001744A@vpn.id2.novell.com>
 <20091007094248.GA1425@ucw.cz>
In-Reply-To: <20091007094248.GA1425@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Pavel Machek <pavel@ucw.cz> 07.10.09 11:44 >>>
>How can userspace "temporarily switch itself" to 64bit mode?

By just determining (or guessing) the 64-bit user mode CS value, and far-
jumping/calling to an address with this CS as the selector.

>Such ability would lead to very interesting behaviour on 32-bit
>kernel, I'd say...

That won't work - you have to have a 64-bit kernel: EFER.LME and the L
bit of some user mode code segment descriptor must be set (or settable).

Consequently a 64-bit kernel could, if it wanted to, make it impossible for
user mode code to do such switching (and an example of this, where
security requires it, is 64-bit Xen disallowing 32-bit para-virtual guests
[kernel or user mode] to switch themselves into 64-bit mode).

Jan

