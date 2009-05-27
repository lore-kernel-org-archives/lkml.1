Return-Path: <linux-kernel-owner+w=401wt.eu-S1764675AbZE0HqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764675AbZE0HqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764365AbZE0Hou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:44:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48867 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764481AbZE0Hos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:44:48 -0400
Message-ID: <4A1CEFC3.2010309@redhat.com>
Date: Wed, 27 May 2009 15:46:11 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jdike@addtoit.com, mingo@elte.hu,
       sparclinux@vger.kernel.org, linux-ia64@vger.kernel.org
Subject: Re: [Patch 4/4] module: trim exception table in module_free()
References: <20090526083717.5050.32719.sendpatchset@localhost.localdomain> <200905271151.28045.rusty@rustcorp.com.au> <4A1CAF44.7000002@redhat.com> <200905271453.51914.rusty@rustcorp.com.au>
In-Reply-To: <200905271453.51914.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> __ex_table ends up with two entries:
>
> Contents of section __ex_table:
>  0000 0c000000 00000000 0e000000 00000000  ................
>  0010 10000000 0a000000 12000000 0a000000  ................
>
> The first is for the __put_user in .text (extable_not_init()) and the second is 
> for the one in .init.text (init()).
>
> Depending on how the module gets allocated, the one referring to .init.text 
> may be first or last.
>   

Hmm, how about the following? :-)

struct exception_table_entry *p = mod->extable;

for (;p <= mod->extable+mod->num_exentries; p++ )
         if (with_in_module_init(p->insn, mod))
                   trim_it(p);



