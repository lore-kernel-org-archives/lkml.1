Return-Path: <linux-kernel-owner+w=401wt.eu-S1762209AbZCYRLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762209AbZCYRLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 13:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754430AbZCYRLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 13:11:08 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:12537 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbZCYRLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 13:11:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TYltmo7nN815iE8w0wEjgj/jxX/ANPpiCvr31dNn5NA3R+qvv9mGmaylU05ebM0qBl
         cie8HBN7ZLAQpm8C57SmhT28C9C+ofecfEFw3tBq1+vS2OXFg9x9ZaHFjTuGI2x8PUiN
         bdBuFLnvvsgM9AyVL1PdpD7WYcem55fvCFMGs=
MIME-Version: 1.0
In-Reply-To: <20090319201008.GC10491@skl-net.de>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
	 <20090318192026.20375.3053.stgit@dwillia2-linux.ch.intel.com>
	 <20090319201008.GC10491@skl-net.de>
Date: Wed, 25 Mar 2009 10:11:04 -0700
X-Google-Sender-Auth: 4f7ed319c3ce5e8e
Message-ID: <e9c3a7c20903251011w3f6b3f58u7c0352ae39bb1c7c@mail.gmail.com>
Subject: Re: [PATCH 02/13] async_tx: don't use src_list argument of 
	async_xor() for dma addresses
From: Dan Williams <dan.j.williams@intel.com>
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de,
       maciej.sosnowski@intel.com, Yuri Tikhonov <yur@emcraft.com>,
       Ilya Yanok <yanok@emcraft.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 1:10 PM, Andre Noll <maan@systemlinux.org> wrote:
> On 12:20, Dan Williams wrote:
>
>> Using src_list argument of async_xor() as a storage for dma addresses
>> implies sizeof(dma_addr_t) <= sizeof(struct page *) restriction which is
>> not always true (e.g. ppc440spe).
>
> This message does not tell what the patch is going to do about that.
> It would also be nice to mention (either in the log message or as a
> comment) why allocating the dma_src arrays on the stack is not going
> to be a problem.
>

True, and taking into account your other comment about the number of
parameters I think this is a good opportunity to solve this problem
rather than kick it down the road.  So I will prepare a rework to make
this memory caller provided.  This gives us the flexibility to use a
kmalloc'd buffer hanging off the stripe_head as Neil suggested in
another thread.

Regards,
Dan
