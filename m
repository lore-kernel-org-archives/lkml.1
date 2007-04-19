Return-Path: <linux-kernel-owner+w=401wt.eu-S1751306AbXDSSsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbXDSSsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 14:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbXDSSsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 14:48:30 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:41691 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbXDSSs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 14:48:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DzLBbzEOec09t1MWEJOygO+r5+1VkWeC8850yhiPFTTAQbTPkyAe2iRvDcd5teRnIuuu/RAG4OD0xOZt/CDVYKxQxu5znpOUkNkfZ9jV3urT8EAm7S0AtW4N3Q+nPGSs2Rd/CD9GmLgj/ZIrACoRu2gxBsJIPsshu2zT7RDEM1g=
Message-ID: <a0a62dfc0704191148v15434469kc3130821cb251072@mail.gmail.com>
Date: Thu, 19 Apr 2007 13:48:27 -0500
From: "Adam Litke" <aglitke@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [RFC 4/8] Enhance fallback functions in libs to support higher order pages
Cc: linux-kernel@vger.kernel.org, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>, "Andi Kleen" <ak@suse.de>,
       "Paul Jackson" <pj@sgi.com>, "Dave Chinner" <dgc@sgi.com>
In-Reply-To: <20070419163525.11948.3482.sendpatchset@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
	 <20070419163525.11948.3482.sendpatchset@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/19/07, Christoph Lameter <clameter@sgi.com> wrote:
> @@ -331,11 +331,15 @@ int simple_prepare_write(struct file *fi
>                         unsigned from, unsigned to)
>  {
>         if (!PageUptodate(page)) {
> -               if (to - from != PAGE_CACHE_SIZE) {
> +               if (to - from != page_cache_size(file->f_mapping)) {

Where do you introduce page_cache_size()?  Is this added by a
different set of patches I should have applied first?

--
Adam Litke ( agl at us.ibm.com )
IBM Linux Technology Center
