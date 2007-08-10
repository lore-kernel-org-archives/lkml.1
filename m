Return-Path: <linux-kernel-owner+w=401wt.eu-S937175AbXHJSrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937175AbXHJSrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 14:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935664AbXHJSqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 14:46:40 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:32864 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760720AbXHJSqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 14:46:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O1EduXiF/TAW5vUO7lzghM4C3PqT+Yo9T2kH3D0AYWFkewD0N36OLQENvOBV1EckPE3AwjuKL+yIJRH43+UfqHmDsRmKOq/9HufL7th4mE5nw+jvQkq4Or7hQIfH4ed+q6+ne/u6U9j0BR9v8MJMDy15sRJp2QwOHx3u9bnIOCU=
Message-ID: <ed5aea430708101146w3c08b499g99317930c7ecbd79@mail.gmail.com>
Date: Fri, 10 Aug 2007 12:46:36 -0600
From: "David Mosberger-Tang" <dmosberger@gmail.com>
To: "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] flush icache before set_pte() on ia64 take9 [2/2] flush icache at set_pte
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-ia64@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       davem@davemloft.net, Zoltan.Menyhart@bull.net, nickpiggin@yahoo.com.au
In-Reply-To: <617E1C2C70743745A92448908E030B2A0224C511@scsmsx411.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070809135311.0676a947.kamezawa.hiroyu@jp.fujitsu.com>
	 <20070809135721.08841cd7.kamezawa.hiroyu@jp.fujitsu.com>
	 <617E1C2C70743745A92448908E030B2A0224C511@scsmsx411.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/10/07, Luck, Tony <tony.luck@intel.com> wrote:

> +       if (pte_exec(pteval) &&    // flush only new executable page.
> +           pte_present(pteval) && // swap out ?
> +           pte_user(pteval) &&    // ignore kernel page
> +           (!pte_present(*ptep) ||// do_no_page or swap in, migration,
> +               pte_pfn(*ptep) != pte_pfn(pteval))) // do_wp_page(), page copy
> +               /* load_module() calles flush_icache_range() explicitly*/
> +               __ia64_sync_icache_dcache(pteval);
>

> So now the only remaining task is to convince myself that this
> new version covers all the cases.

What about code-size?

Also, is it OK to call a function from all places where a set_pte() is
being done?  I'd hope so, but it's a really low-level operation...

  --david
-- 
Mosberger Consulting LLC, http://www.mosberger-consulting.com/
