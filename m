Return-Path: <linux-kernel-owner+w=401wt.eu-S1945926AbXC3DyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945926AbXC3DyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 23:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945929AbXC3DyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 23:54:01 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:23720 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945926AbXC3DyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 23:54:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=G8J/CIOzAoH6DWMPQ/uMZyb46pVzMdy6KSe689EZWxy2kKJxc6TZ373MwpEWiCQtghElzTTeM8miyUji5qY9npRGwICEAWX0PFSiEhb18+7Yykr2RaYfw3ZBnqMJgzGZvrOGYflIrYYQ8gaVTqSH6sS3lC8zz+wSSJPn2kB7mEU=
Message-ID: <8bd0f97a0703292053l2391d6eeh7440d7633301fdae@mail.gmail.com>
Date: Thu, 29 Mar 2007 23:53:59 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: bryan.wu@analog.com
Subject: Re: [PATCH] nommu arch dont zero the anonymous mapping by adding UNINITIALIZE flag
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "David Howells" <dhowells@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1175226172.15391.66.camel@roc-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1175226172.15391.66.camel@roc-desktop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/29/07, Wu, Bryan <bryan.wu@analog.com> wrote:
> On architectures with MMU, malloc takes about the same speed,
> indepentant of malloc size, while on the Blackfin (NOMMU), as the malloc
> size increases, the time that malloc consumes grows....

err, this is not the direction we wanted to go ... this requires
changes to the user<->kernel boundary which certainly will be rejected
by the glibc maintainers since it implies breakage in POSIX behavior
and is specific to no-mmu only ...

the plan is to hold onto this cruft in Blackfin until we get this bug
sorted out:
http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=3027

as the thing we'll send to mainline will be sane (a no-mmu specific
kconfig option to control the memset in the kernel malloc)

the memset in the kernel right now for no-mmu is by design, not defect
... we can chat about this more via Blackfin channels if you like, or
just wait till we meet up in Shanghai
-mike
