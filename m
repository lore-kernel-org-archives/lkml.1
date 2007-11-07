Return-Path: <linux-kernel-owner+w=401wt.eu-S1757913AbXKGNQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913AbXKGNQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 08:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbXKGNQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 08:16:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbXKGNQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 08:16:07 -0500
Message-ID: <4731BAB2.9040004@redhat.com>
Date: Wed, 07 Nov 2007 11:16:34 -0200
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070811)
MIME-Version: 1.0
To: Akio Takebe <takebe_akio@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, jeremy@goop.org, hollisb@us.ibm.com,
       kvm-devel@lists.sourceforge.net, avi@qumranet.com
Subject: Re: [kvm-devel] include files for kvmclock
References: <11943875362987-git-send-email-gcosta@redhat.com> <11943875433821-git-send-email-gcosta@redhat.com> <1DC8211684B62Btakebe_akio@jp.fujitsu.com>
In-Reply-To: <1DC8211684B62Btakebe_akio@jp.fujitsu.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Akio Takebe escreveu:
> Hi, Glauber
> 
> This is interesting facility. :-)
> 
>> +#define KVM_HCALL_REGISTER_CLOCK	1
>> +
>> +union kvm_hv_clock {
>> +	struct {
>> +		u64 tsc_mult;
>> +		u64 now_ns;
>> +		/* That's the wall clock, not the water closet */
>> +		u64 wc_sec;
>> +		u64 wc_nsec;
>> +		u64 last_tsc;
>> +		/* At first, we could use the tsc value as a marker, but Jeremy
>> +		 * well noted that it will cause us locking problems in 32-bit
>> +		 * sys, so we have a special version field */
>> +		u32 version;
>> +	};
>> +	char page_align[PAGE_SIZE];
>> +};
>> +
> Why does kvm_hv_clock need page_align?
Each vcpu will register a page on its own. In the guest side, it will be
an array of pages. So, we make it page sized.

> And also the kvm_hv_clock is alloced with kvm_vcpu,
There's no requirements on the host part at all. So it doesn't really
matter. In the next version, I may make it even a simple pointer.

> so the align is not enough, isn't it?
> I thik __atribute__((__aligne__(PAGE_SIZE)))) is better than it.
It deals with the start of the structure, but not with its size. See the
guest part: Where it matters, I do use it.


Thanks

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Remi - http://enigmail.mozdev.org

iD8DBQFHMbqyjYI8LaFUWXMRAgfOAKCTeKF3cWbhILYSXY+MjtXo8B87EwCeNNhn
z9RDYaCWHIxsqlciMF0i27w=
=EIEM
-----END PGP SIGNATURE-----
