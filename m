Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbYL0KIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbYL0KIT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 05:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbYL0KIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 05:08:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752608AbYL0KIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 05:08:09 -0500
Date: Sat, 27 Dec 2008 02:07:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi@firstfloor.org>, randy.dunlap@oracle.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: Eliminate atleast 10684 sparse warnings
Message-Id: <20081227020734.3592507e.akpm@linux-foundation.org>
In-Reply-To: <1230371496.3276.4.camel@jaswinder.satnam>
References: <1230371496.3276.4.camel@jaswinder.satnam>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Dec 2008 15:21:36 +0530 Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:

>  #ifdef CONFIG_ILLEGAL_POINTER_VALUE
> -# define POISON_POINTER_DELTA CONFIG_ILLEGAL_POINTER_VALUE
> +# define POISON_POINTER_DELTA _AC(CONFIG_ILLEGAL_POINTER_VALUE, UL)
>  #else
>  # define POISON_POINTER_DELTA 0
>  #endif

So now

commit 948f984df52511bb0efa5c026813b0c34de43aa0
Author:     Avi Kivity <avi@qumranet.com>
AuthorDate: Tue May 20 14:39:25 2008 +0300
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Tue May 20 13:42:31 2008 +0200

    core, x86: make LIST_POISON less deadly

gets splattered across three commits (at least).  Sigh.

(how come that patch is 7 moonths old and still unmerged, btw?)
