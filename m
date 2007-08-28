Return-Path: <linux-kernel-owner+w=401wt.eu-S1760564AbXH1AOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760564AbXH1AOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 20:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755907AbXH1AOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 20:14:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:61753 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167AbXH1AOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 20:14:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BiOkl3yDpug/ily8STRSNPbU19PRYKdngaiteTYRjtBeAj4pFNOHQNyCh3aYCF27ikqTNCq8/Y7AINpp5WXZcymytDk+XEGwCG5arRxpLJJ6ab+h5/NjENoG1rPygAZN0Zd11VStpPBjXxLFncqhtggb3OHlEsKPnLBDlvsEuGI=
Message-ID: <6bffcb0e0708271714m140d39f3pf89bdc3d97808578@mail.gmail.com>
Date: Tue, 28 Aug 2007 02:14:30 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Joe Perches" <joe@perches.com>
Subject: Re: [PATCH] trivial - convert "for(foo=0;foo<NR_CPUS;foo++)" to "for_each_possible_cpu(foo)"
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, "Mike Travis" <travis@sgi.com>
In-Reply-To: <1188258887.18004.173.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1188258887.18004.173.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On 28/08/07, Joe Perches <joe@perches.com> wrote:
> Done via grep/sed and compile tested i386 with xen
>
> Changed the foo++ and ++foo forms
[snip]
> There are 3 more lines that could be modified:
>
> arch/powerpc/sysdev/mpic.c:     for (i = 0; i < NR_CPUS; ++i, cpumask >>= 1)

for_each_possible_cpu(i) {
[..]
cpumask >>= 1;
}

> arch/sparc/kernel/smp.c:        for (cpu = 0, num = 0; cpu < NR_CPUS; cpu++)

num = 0;
for_each_possible_cpu(cpu) {
[..]
}

> arch/sparc64/kernel/smp.c:      for (i = 0; i < NR_CPUS; i++, ptr += size)

for_each_possible_cpu(i) {
[..]
ptr += size;
}

BTW1. There is a huge difference between pre and post incrementation -
have you checked all cases?

BTW2. Could you convert each i -> cpu?

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
