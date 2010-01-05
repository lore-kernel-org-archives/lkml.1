Return-Path: <linux-kernel-owner+w=401wt.eu-S1755111Ab0AETFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab0AETFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562Ab0AETFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:05:36 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40842 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab0AETFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:05:35 -0500
Date: Tue, 5 Jan 2010 19:04:55 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-arch@vger.kernel.org,
       ebiederm@xmission.com, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/9] Add a kernel_address() that works for data too
Message-ID: <20100105190455.GE30868@flint.arm.linux.org.uk>
Mail-Followup-To: Sam Ravnborg <sam@ravnborg.org>,
	Andi Kleen <andi@firstfloor.org>, linux-arch@vger.kernel.org,
	ebiederm@xmission.com, paulmck@linux.vnet.ibm.com,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20100105315.789846878@firstfloor.org> <20100105021527.1AB19B17C2@basil.firstfloor.org> <20100105085853.GA28126@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105085853.GA28126@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 09:58:53AM +0100, Sam Ravnborg wrote:
> But you can trust _etext an almost all architectures.
> It is a bug if it is missing.
> 
> So [_text, _etext] is the text section.
> 
> The data section may be placed before or after - it depends on the architecture.
> But again - only some architectures define _sdata.
> But all? define _edata.

You can not guarantee that the data segment is after the text segment,
unless you want to outlaw XIP kernels.  XIP kernels have the text
segment mapped at a completely different address to the data segment.

I'd suggest the only way to identify the data segment in a generic way
is to have everyone define _sdata, or more preferably _data (to be
consistent with _text), to be the start of the data segment.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
