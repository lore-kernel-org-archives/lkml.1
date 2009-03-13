Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbZCMICk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbZCMICk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbZCMIC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:02:27 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:17293 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbZCMIC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:02:26 -0400
Message-Id: <49BA214B.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 13 Mar 2009 08:03:07 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] initconst adjustments
References: <49B8F8E9.76E4.0078.0@novell.com>
 <20090312221747.GA14921@uranus.ravnborg.org>
In-Reply-To: <20090312221747.GA14921@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Sam Ravnborg <sam@ravnborg.org> 12.03.09 23:17 >>>
>On Thu, Mar 12, 2009 at 10:58:33AM +0000, Jan Beulich wrote:
>> +#define INIT_SECTIONS      ".init.*"
>> +#define DEV_INIT_SECTIONS  ".devinit.*"
>> +#define CPU_INIT_SECTIONS  ".cpuinit.*"
>> +#define MEM_INIT_SECTIONS  ".meminit.*"
>> +
>> +#define EXIT_SECTIONS      ".exit.*"
>> +#define DEV_EXIT_SECTIONS  ".devexit.*"
>> +#define CPU_EXIT_SECTIONS  ".cpuexit.*"
>> +#define MEM_EXIT_SECTIONS  ".memexit.*"
>
>The abvoe simplification now makes us math all sections that starts with
>for example .init. - and we have seen sections named .init.1 for example.

But that exactly is intended: Anything named .init.* should be what its
name says - init-only code or data. Even (if it was used anywhere) .init
itself should be this and nothing else. Any other use of such a name is
really broken imo.

>So I'm afraid that we will simply match too many sections here on the various
>architectures.
>
>
>A quick grep showed for example:
>arch/blackfin/kernel/vmlinux.lds.S:     .init.setup :
>arch/blackfin/kernel/vmlinux.lds.S:             *(.init.setup)
>arch/blackfin/kernel/vmlinux.lds.S:     .init.ramfs :
>arch/blackfin/kernel/vmlinux.lds.S:             *(.init.ramfs)

Which is precisely a case that we want to cover: These two sections are
init-only data (and site between ___init_begin and ___init_end, and hence
ought to be subject of the modpost checking.

Jan

