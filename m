Return-Path: <linux-kernel-owner+w=401wt.eu-S1756247AbZBSSmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbZBSSmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 13:42:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbZBSSlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 13:41:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33381 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbZBSSlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 13:41:49 -0500
Message-ID: <499DA727.2060606@zytor.com>
Date: Thu, 19 Feb 2009 10:38:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Petr Tesarik <ptesarik@suse.cz>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Definition of BUG on x86
References: <1234975856.15053.16.camel@nathan.suse.cz>	 <499C4786.5010504@goop.org> <1235043648.15053.35.camel@nathan.suse.cz>
In-Reply-To: <1235043648.15053.35.camel@nathan.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Tesarik wrote:
> 
> Ah, yes, you're right. If you want to make gcc aware of the fact that a
> function never returns, it must recognize that there is no path to that
> function's EXIT, otherwise it will emit a warning (which is pretty
> annoying, indeed). Since we don't want to make a call/jmp to an external
> noreturn function, so the no-return code must be directly visible to
> gcc. Unfortunately, there is no way of telling gcc that an asm statement
> does not return.
> 

At Transmeta, we had an internal hack to gcc that added
__builtin_not_reached(); for this particular reason.  This would
probably be the best way to handle this.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

