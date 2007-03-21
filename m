Return-Path: <linux-kernel-owner+w=401wt.eu-S1752266AbXCUMNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbXCUMNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 08:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbXCUMNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 08:13:55 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:23811 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbXCUMNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 08:13:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ni06C5Wkx64FuLEewTYCM+Kg7vM4mLz5XgDpeZ0czgrZ+j32U6xoyPkK+8fianlhB3gP3Refc5srSyulkYZ1cgvdlI8kYj+5Rb0oZaInREe50SeJ1BwdcXz4wAhUocz5v5p8Qi/xacECQDcUHJKPU6HLHG4LATzeUvXd0b3mejU=
Message-ID: <84144f020703210513i37d1576erb7814483bcaad505@mail.gmail.com>
Date: Wed, 21 Mar 2007 14:13:52 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Jarek Poplawski" <jarkao2@o2.pl>
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
Cc: "Eric Dumazet" <dada1@cosmosbay.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, mpm@selenic.com,
       "Christoph Lameter" <clameter@sgi.com>, "ast@domdv.de" <ast@domdv.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070321101143.GB1939@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703200943430.3622@sbz-30.cs.Helsinki.FI>
	 <20070321101143.GB1939@ff.dom.local>
X-Google-Sender-Auth: 676dec3d6b723e76
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/21/07, Jarek Poplawski <jarkao2@o2.pl> wrote:
> I think Pekka was right (it looks he changed his mind now) something
> should be done here. I think something like this should be a minimum:
>
> BUG_ON(!objp || virt_to_cache(objp) != cachep);
>
> to show distinctly what's going on.

No, if we were to add a NULL check in kmem_cache_free(), it should
behave like kfree() does. Anyway, if you feel about this strongly I
suspect the best solution is to add a __kmem_cache_free which does
_not_ have the NULL check and convert those super-hot paths to use it.
Sort of what Andrew suggested already.
