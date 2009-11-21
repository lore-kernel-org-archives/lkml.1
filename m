Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbZKUQRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbZKUQRt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 11:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbZKUQRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 11:17:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbZKUQRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 11:17:47 -0500
Subject: Re: [PATCH] mm/nommu.c: Fix improperly call of security API in mmap
From: Eric Paris <eparis@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, graff.yang@gmail.com,
       linux-kernel@vger.kernel.org, gyang@blackfin.uclinux.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Graff Yang <graf.yang@analog.com>,
       linux-security-module@vger.kernel.org, john.johansen@canonical.com
In-Reply-To: <20163.1258762608@redhat.com>
References: <1258745522.2916.3.camel@dhcp231-106.rdu.redhat.com>
	 <20091120094217.b94d99bb.akpm@linux-foundation.org>
	 <20091117141314.0238a49b.akpm@linux-foundation.org>
	 <1255706463.15182.84.camel@dhcp231-106.rdu.redhat.com>
	 <7e0fb38c0910160801o50346a5cm763d79cab98272a5@mail.gmail.com>
	 <1255516134-4838-1-git-send-email-graff.yang@gmail.com>
	 <18475.1255529305@redhat.com> <6207.1255706090@redhat.com>
	 <23382.1255707790@redhat.com>
	 <1255708529.15182.95.camel@dhcp231-106.rdu.redhat.com>
	 <16299.1258729209@redhat.com> <18122.1258739664@redhat.com>
	 <20163.1258762608@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 Nov 2009 11:15:46 -0500
Message-Id: <1258820146.2916.56.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-11-21 at 00:16 +0000, David Howells wrote:
> Eric Paris <eparis@redhat.com> wrote:
> 
> > +/* sec_flags for security_file_mmap */
> > +#define SECURITY_MMAP_ADDR_ONLY	0x01
> > +#define SECURITY_MMAP_NOT_ADDR	0x02
> 
> Please add comments to these to indicate what they're intended to convey.
> Would ADDR_ONLY be better as EXACT_ADDR?

I think I should point out that this hook checks 2 things.  Originally
it was only used to check if a file should be allowed to be mmaped.  It
was later enhanced to check if the return address of mmap, if it is file
backed or anonymous, is acceptable.  These flags only influence the
later.

ADDR_ONLY means the security system should only check the address.
NOT_ADDR means they security system should not check the address.

You need ADDR_ONLY when the hook is called on map that is not file
backed or where that has already been dealt with.  You need NOT_ADDR
only for nommu where the whole idea of mmap_min_addr is pointless.

I'm not sure what comments would convey....

/* security hook should only check the address */
#define SECURITY_MMAP_ADDR_ONLY	0x01
/* security hook should not check the address */
#define SECURITY_MMAP_NOT_ADDR	0x02

Does that add something?

Still haven't heard where people scream they absolutely need this today,
so I'm going to ask James to carry it in his for-next tree.

