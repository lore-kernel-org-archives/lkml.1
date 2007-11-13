Return-Path: <linux-kernel-owner+w=401wt.eu-S1759077AbXKMMR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077AbXKMMR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 07:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbXKMMRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 07:17:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487AbXKMMRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 07:17:46 -0500
Message-ID: <4739906B.2080103@redhat.com>
Date: Tue, 13 Nov 2007 09:54:19 -0200
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070811)
MIME-Version: 1.0
To: "Dong, Eddie" <eddie.dong@intel.com>
CC: linux-kernel@vger.kernel.org, jeremy@goop.org, hollisb@us.ibm.com,
       kvm-devel@lists.sourceforge.net, avi@qumranet.com
Subject: Re: [kvm-devel] [PATCH 2/3] kvmclock - the host part.
References: <11945615632624-git-send-email-gcosta@redhat.com><11945615703593-git-send-email-gcosta@redhat.com> <11945615751747-git-send-email-gcosta@redhat.com> <10EA09EFD8728347A513008B6B0DA77A025DF8A2@pdsmsx411.ccr.corp.intel.com>
In-Reply-To: <10EA09EFD8728347A513008B6B0DA77A025DF8A2@pdsmsx411.ccr.corp.intel.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Dong, Eddie escreveu:
>> +static void kvm_write_guest_time(struct kvm_vcpu *vcpu) +{
>> +	struct timespec ts;
>> +	int r;
>> +
>> +	if (!vcpu->clock_gpa)
>> +		return;
>> +
>> +	/* Updates version to the next odd number, indicating
>> we're writing */
>> +	vcpu->hv_clock.version++;
>> +	kvm_write_guest(vcpu->kvm, vcpu->clock_gpa,
>> &vcpu->hv_clock, PAGE_SIZE);
>> +
>> +	kvm_get_msr(vcpu, MSR_IA32_TIME_STAMP_COUNTER,
>> +			  &vcpu->hv_clock.last_tsc);
>> +
>> +	ktime_get_ts(&ts);
> 
> Do we need to disable preemption here?
After thinking for a little while, you are theoretically right.
In the current state, we could even be preempted between all operations
;-) Maybe after avi's suggestion of moving the call to it it will end up
in a preempt safe region, but anyway, it's safer to add the preempt
markers here.
I'll put it in next version, thanks

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Remi - http://enigmail.mozdev.org

iD8DBQFHOZBrjYI8LaFUWXMRAo81AKCfbkzhLl7F6BUjzUHVyErCFeHxFACg1teB
eqsOnJiAqB3JiYf+2YdMZ4o=
=ENKU
-----END PGP SIGNATURE-----
