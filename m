Return-Path: <linux-kernel-owner+w=401wt.eu-S1756474AbZKWKKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbZKWKKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 05:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756749AbZKWKKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 05:10:30 -0500
Received: from adelie.canonical.com ([91.189.90.139]:35785 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704AbZKWKK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 05:10:29 -0500
Message-ID: <4B0A5F8D.6090707@canonical.com>
Date: Mon, 23 Nov 2009 02:10:21 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, graff.yang@gmail.com,
       linux-kernel@vger.kernel.org, gyang@blackfin.uclinux.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Graff Yang <graf.yang@analog.com>,
       linux-security-module@vger.kernel.org, john.johansen@canonical.com
Subject: Re: [PATCH] mm/nommu.c: Fix improperly call of security API in mmap
References: <1258745522.2916.3.camel@dhcp231-106.rdu.redhat.com>	 <20091120094217.b94d99bb.akpm@linux-foundation.org>	 <20091117141314.0238a49b.akpm@linux-foundation.org>	 <1255706463.15182.84.camel@dhcp231-106.rdu.redhat.com>	 <7e0fb38c0910160801o50346a5cm763d79cab98272a5@mail.gmail.com>	 <1255516134-4838-1-git-send-email-graff.yang@gmail.com>	 <18475.1255529305@redhat.com> <6207.1255706090@redhat.com>	 <23382.1255707790@redhat.com>	 <1255708529.15182.95.camel@dhcp231-106.rdu.redhat.com>	 <16299.1258729209@redhat.com> <18122.1258739664@redhat.com>	 <20163.1258762608@redhat.com> <1258820146.2916.56.camel@dhcp231-106.rdu.redhat.com>
In-Reply-To: <1258820146.2916.56.camel@dhcp231-106.rdu.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote:
> On Sat, 2009-11-21 at 00:16 +0000, David Howells wrote:
>> Eric Paris <eparis@redhat.com> wrote:
>>
>>> +/* sec_flags for security_file_mmap */
>>> +#define SECURITY_MMAP_ADDR_ONLY	0x01
>>> +#define SECURITY_MMAP_NOT_ADDR	0x02
>> Please add comments to these to indicate what they're intended to convey.
>> Would ADDR_ONLY be better as EXACT_ADDR?
> 
> I think I should point out that this hook checks 2 things.  Originally
> it was only used to check if a file should be allowed to be mmaped.  It
> was later enhanced to check if the return address of mmap, if it is file
> backed or anonymous, is acceptable.  These flags only influence the
> later.
> 
> ADDR_ONLY means the security system should only check the address.
> NOT_ADDR means they security system should not check the address.
> 
> You need ADDR_ONLY when the hook is called on map that is not file
> backed or where that has already been dealt with.  You need NOT_ADDR
> only for nommu where the whole idea of mmap_min_addr is pointless.
> 
> I'm not sure what comments would convey....
> 
> /* security hook should only check the address */
> #define SECURITY_MMAP_ADDR_ONLY	0x01
> /* security hook should not check the address */
> #define SECURITY_MMAP_NOT_ADDR	0x02
> 
> Does that add something?
> 
> Still haven't heard where people scream they absolutely need this today,
> so I'm going to ask James to carry it in his for-next tree.
> 
The comments convey a tad more but I don't think they are necessary, and
I concur, it would be good if it went into the for-next tree.

