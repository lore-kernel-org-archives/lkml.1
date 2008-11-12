Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbYKLUCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbYKLUCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 15:02:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbYKLUCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 15:02:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36256 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbYKLUCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 15:02:31 -0500
Message-ID: <491B358D.2040304@kernel.org>
Date: Wed, 12 Nov 2008 11:59:09 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Bernhard Walle <bwalle@suse.de>
CC: x86@kernel.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH] Always use 64 bit addresses for the firmware memory map
References: <1226519089-21647-1-git-send-email-bwalle@suse.de>
In-Reply-To: <1226519089-21647-1-git-send-email-bwalle@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Walle wrote:
> I had a problem that on i386 without PAE enabled the firmware memory map was
> wrong because a 64 bit address has been truncated:
> 
>         0000000000000000-000000000009f400 (System RAM)
>         000000000009f400-00000000000a0000 (reserved)
>         00000000fec10000-00000000fec11000 (reserved)
>         00000000fec20000-00000000fec21000 (reserved)
>         00000000fee00000-00000000fee10000 (reserved)
>         00000000ff800000-0000000100000000 (reserved)
>  --->   0000000000000000-00000000fffff000 (System RAM)  <---
>         00000000000f0000-0000000000100000 (reserved)
>         0000000000100000-00000000f57fa000 (System RAM)
>         00000000f57fa000-00000000f5800000 (ACPI Tables)
>         00000000fdc00000-00000000fdc01000 (reserved)
>         00000000fdc10000-00000000fdc11000 (reserved)
>         00000000fdc20000-00000000fdc21000 (reserved)
>         00000000fdc30000-00000000fdc31000 (reserved)
>         00000000fec00000-00000000fec01000 (reserved)
> 
> Just always using 64 bit is the most sane approach in my opinion.
> 
> 
> Signed-off-by: Bernhard Walle <bwalle@suse.de>

There are two options: either filter addresses outside the
resource_size_t range (since we don't manage that space and therefore
don't care about it) or, as you do, enforce 64-bitness.

I want to make sure, though, that we don't just end up pushing the
truncation further down in the code.

	-hpa
