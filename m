Return-Path: <linux-kernel-owner+w=401wt.eu-S1761164AbYFKS6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761164AbYFKS6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761625AbYFKSyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:54:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:64157 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765306AbYFKSyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:54:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lZADxBZUey1hLFXhjPqEVoqYG7pEf3VQmhMdeih8cEehL79EgmUbIzc9goZ454peud
         kv4JBgB65LhZyXUoXJjgUqCRuxmn1MEVzq5MaaKDtsLmCCc4qepVhCKM+F+5ghKeeVu7
         sk2nvDr1OmGKDMxFLTMm2JE5cpO7R4f38pQ/E=
Message-ID: <19f34abd0806111154q77739a2m8dcff24e2f9a3922@mail.gmail.com>
Date: Wed, 11 Jun 2008 20:54:46 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH] modules: Take a shortcut for checking if an address is in a module
Cc: "Rusty Russell" <rusty@rustcorp.com.au>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080611081847.0b22079c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080610130519.21bc66f3@infradead.org>
	 <200806112112.08623.rusty@rustcorp.com.au>
	 <20080611081847.0b22079c@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/08, Arjan van de Ven <arjan@infradead.org> wrote:
> On Wed, 11 Jun 2008 21:12:08 +1000
>  Rusty Russell <rusty@rustcorp.com.au> wrote:
>
>  > On Wednesday 11 June 2008 06:05:19 Arjan van de Ven wrote:
>  > > From: Arjan van de Ven <arjan@linux.intel.com>
>  > > Subject: [PATCH] modules: Take a shortcut for checking if an
>  > > address is in a module
>  > >
>  > > Various pieces of the kernel (lockdep, latencytop, etc) tend to
>  > > store backtraces, sometimes at a relatively high frequency. In
>  > > itself this isn't a big performance deal (after all you're using
>  > > diagnostics features), but there have been some complaints from
>  > > people who have over 100 modules loaded that this is a tad too slow.

Would it be overkill to simply drop the module addresses in an rbtree
and use that instead of a linear search over all the modules?

It would probably take a fair number of lines in C, and with a little
memory overhead, but the speed-up should be great. Should I give it a
try? (It would be arch-independent too.)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
