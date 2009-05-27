Return-Path: <linux-kernel-owner+w=401wt.eu-S1759876AbZE0Fq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759876AbZE0Fq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 01:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbZE0Fqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 01:46:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58679 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbZE0Fqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 01:46:46 -0400
Message-ID: <4A1CD41C.1000008@redhat.com>
Date: Wed, 27 May 2009 13:48:12 +0800
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

Hmm, I understand now. The problem is that we don't know which entries
are for __init, and which are not...

> (You can see here why we haven't fixed this: exceptions in __init in modules 
> are rare, perhaps non-existent).
>   
Agreed.
Is it possible to put extable for __init in a separate section?

Thanks for your explanation!

