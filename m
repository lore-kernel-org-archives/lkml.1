Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbZGAHAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbZGAHAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 03:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbZGAHA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 03:00:26 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:27082 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbZGAHA0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 03:00:26 -0400
Message-Id: <4A4B25AA020000780000861D@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Wed, 01 Jul 2009 08:00:26 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Cc: "Ingo Molnar" <mingo@elte.hu>, <tony.luck@intel.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, <linux-arch@vger.kernel.org>,
       <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <hpa@zytor.com>
Subject: Re: [PATCH] reduce export symbol CRC table size on 64-bit
	 archs
References: <4A4A18780200007800008345@vpn.id2.novell.com>
 <200907011430.29524.rusty@rustcorp.com.au>
In-Reply-To: <200907011430.29524.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Rusty Russell <rusty@rustcorp.com.au> 01.07.09 07:00 >>>
>On Tue, 30 Jun 2009 09:21:52 pm Jan Beulich wrote:
>> Since these CRCs are really only 32-bit quantities, there's no need to
>> store them in 64-bit slots. Since, however, gcc doesn't allow
>> respective initializations, asm() constructs get used to create the CRC
>> tables (and its for that reason that the patch only makes x86-64 and
>> ia64 utilize that functionality, as I can't verify this doesn't break
>> in some subtle way elsewhere).
>
>Hmm, can we change the build system to just link this in as a normal table, 
>rather than use linker tricks?
>
>Then genksyms would just spit out a C file we could compile and link into final 
>vmlinux.

That's going to be non-trivial, because of the ordering that's required to be
identical between the symbol and the CRC tables. Basically that would mean
that genksyms would need to look at either the assembly output or the
object file, which would further slow down the build process. Compared to
that the asm() solution in the patch sent seems more strait forward (despite
it possibly looking convoluted at the first glance).

Jan

