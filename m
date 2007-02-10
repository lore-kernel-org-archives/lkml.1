Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbXBJWOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbXBJWOa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 17:14:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbXBJWOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 17:14:30 -0500
Received: from wx-out-0506.google.com ([66.249.82.231]:26761 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbXBJWO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 17:14:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=d2lL9jFySLUetxEJL8qNi7gCHpWUsEebYrUqFdp9HCzagEp7jZVG8CdUomqIxVxXlfur2ekEp45CtpUQjymwYECoZnxK51lAr56Gf/3foFuYSMRfxF1NiglV48WUJ3vD9FobMB6EHg7ARQHbfjtcgqsJLVVuOztavyDyYZAcjSs=
Message-ID: <45CE43B5.2020806@gmail.com>
Date: Sat, 10 Feb 2007 17:14:13 -0500
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: Re: [PATCH] iomap: make PCI iomap stuff excluded when PCI isn't configured
References: <20070210114314.GB12642@osiris.boeblingen.de.ibm.com> <45CE0434.30105@gmail.com> <20070210194630.GA13416@osiris.ibm.com>
In-Reply-To: <20070210194630.GA13416@osiris.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
> On Sat, Feb 10, 2007 at 12:43:16PM -0500, Tejun Heo wrote:
\>> Heiko, how about this?  Does it fix s390?
> 
> Unfortunately not. Now I get
> 
>   CC      lib/iomap.o
> lib/iomap.c: In function 'devm_ioport_map_release':
> lib/iomap.c:270: warning: implicit declaration of function 'ioport_unmap'
> lib/iomap.c: In function 'devm_ioport_map':
> lib/iomap.c:297: warning: implicit declaration of function 'ioport_map'
> lib/iomap.c:297: warning: assignment makes pointer from integer without a cast

I think an arch needs to support ioport_map/unmap and noncoherent dma 
(just alias to coherent interface on x86/amd64) interface whether PCI is 
implemented or not.  No?

-- 
tejun
