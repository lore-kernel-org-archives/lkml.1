Return-Path: <linux-kernel-owner+w=401wt.eu-S934553AbXGTREb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934553AbXGTREb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 13:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936168AbXGTRDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 13:03:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43075 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229AbXGTRDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 13:03:36 -0400
Message-ID: <46A0EAC8.9020203@zytor.com>
Date: Fri, 20 Jul 2007 10:03:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>, Andi Kleen <ak@novell.com>,
       Arthur Jones <arthur.jones@qlogic.com>,
       Vasily Tarasov <vtaras@openvz.org>, linux-kernel@vger.kernel.org,
       Jan Kara <jack@ucw.cz>, linux-arch@vger.kernel.org
Subject: Re: build fix for x86_64...
References: <617E1C2C70743745A92448908E030B2A01FA46A9@scsmsx411.amr.corp.intel.com>
In-Reply-To: <617E1C2C70743745A92448908E030B2A01FA46A9@scsmsx411.amr.corp.intel.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luck, Tony wrote:
> 
> Which is better.  But if we unconditionally set this CONFIG variable, then the
> code in fs/quota.c will have to read:
> 
> #if defined(CONFIG_COMPAT) && defined(CONFIG_COMPAT_FOR_U64_ALIGNMENT)
> 
> We can keep it simpler if the Kconfig file does the conditional for us:
> 
> config COMPAT_FOR_U64_ALIGNMENT
> 	def_bool y
> 	depends on COMPAT
> 

No, that would be bad.  If compat_u64 is used to carry 32-bit ABIs
forward into 64-bit space without needing compatibility hacks, then this
would actually introduce ABI incompatibilities depending on CONFIG_COMPAT!

	-hpa
