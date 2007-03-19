Return-Path: <linux-kernel-owner+w=401wt.eu-S1030748AbXCSXf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030748AbXCSXf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 19:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030747AbXCSXf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 19:35:29 -0400
Received: from ozlabs.org ([203.10.76.45]:49530 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030748AbXCSXf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 19:35:29 -0400
Subject: Re: [PATCH v3] Race between cat /proc/kallsyms and rmmod
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org,
       pmarques@grupopie.com
In-Reply-To: <20070319143317.GB6805@localhost.sw.ru>
References: <20070316114245.GA6817@localhost.sw.ru>
	 <20070319143317.GB6805@localhost.sw.ru>
Content-Type: text/plain
Date: Tue, 20 Mar 2007 10:35:11 +1100
Message-Id: <1174347311.11680.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 17:33 +0300, Alexey Dobriyan wrote:
> Iterating code of /proc/kallsyms calls module_get_kallsym() which grabs
> and drops module_mutex internally and returns "struct module *",
> module is removed, aforementioned "struct module *" is used in non-trivial
> way.

Hi Alexey,

	I like the patch, but I wonder if passing the lengths for the symbol
and module name is overkill?  There are KSYM_NAME_LEN and
MODULE_NAME_LEN constants, after all, and we could just have the callers
use buffers of sufficient size.  Simplifies the code and reduces
confusion if someone passes a small buffer and it gets surprisingly
truncated...

Thanks!
Rusty.


