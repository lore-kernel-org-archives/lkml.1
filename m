Return-Path: <linux-kernel-owner+w=401wt.eu-S936726AbXHHXSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936726AbXHHXSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 19:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935556AbXHHXSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 19:18:25 -0400
Received: from el-out-1112.google.com ([209.85.162.183]:22975 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936374AbXHHXSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 19:18:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Uc+yVhSKh5GkWKa2l09msjsxa2gOerKAiR2ieSfArSzw8veSF95KS4XlNfLvqRgd4OVKS+txdjEsiXMvIMiuQjiudrNVOt6aRSUUMBg8aVMwpPr1qYQJbauBCnFysZ04LBO3Jaf5q8A2Ca+9mAPgVZIGtDZ4AnPPW8fYgFNqQcU=
Message-ID: <9a8748490708081618p43cdcdfdn5de6f292247def5b@mail.gmail.com>
Date: Thu, 9 Aug 2007 01:18:22 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Chris Snook" <csnook@redhat.com>
Subject: Re: [PATCH] make atomic_t volatile on all architectures
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, cfriesen@nortel.com, zlynx@acm.org
In-Reply-To: <20070808230733.GA17270@shell.boston.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070808230733.GA17270@shell.boston.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2007, Chris Snook <csnook@redhat.com> wrote:
> From: Chris Snook <csnook@redhat.com>
>
> Some architectures currently do not declare the contents of an atomic_t to be
> volatile.  This causes confusion since atomic_read() might not actually read
> anything if an optimizing compiler re-uses a value stored in a register, which
> can break code that loops until something external changes the value of an
> atomic_t.  Avoiding such bugs requires using barrier(), which causes re-loads
> of all registers used in the loop, thus hurting performance instead of helping
> it, particularly on architectures where it's unnecessary.  Since we generally
> want to re-read the contents of an atomic variable on every access anyway,
> let's standardize the behavior across all architectures and avoid the
> performance and correctness problems of requiring the use of barrier() in
> loops that expect atomic_t variables to change externally.  This is relevant
> even on non-smp architectures, since drivers may use atomic operations in
> interrupt handlers.
>
> Signed-off-by: Chris Snook <csnook@redhat.com>
>

Hmm, I thought we were trying to move away from volatile since it is
very weakly defined and towards explicit barriers and locks...
Points to --> Documentation/volatile-considered-harmful.txt


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
