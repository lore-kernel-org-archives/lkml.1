Return-Path: <linux-kernel-owner+w=401wt.eu-S1752244AbXCDSdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbXCDSdJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 13:33:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbXCDSdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 13:33:09 -0500
Received: from wx-out-0506.google.com ([66.249.82.226]:11017 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbXCDSdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 13:33:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=mM+EDC3OJpM76l7ygC2q6a7KsTVUM02OVwjNiyRhOwEDn0bZStR+IDVm/HVt46B2VUdzdPndxcrv2nAfTmAIdQ2qVzXKZUoWuYS58iBnaJDXVpcq5tBG+RvnNfyzmJfYOd300jUrXvTR91YT3k2ic15ChOWpMtCVcduqg7fJE/8=
Message-ID: <3d8471ca0703041033v689b51dfuba0b09fc979d7698@mail.gmail.com>
Date: Sun, 4 Mar 2007 19:33:06 +0100
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [1/3] Bugfix: Don't use the TSC in sched_clock if unstable
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <200703041825.39361.ak@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_118976_19025661.1173033186790"
References: <3d8471ca0703031341l1768fe7rccf40712e452ea09@mail.gmail.com>
	 <200703041537.27581.ak@suse.de>
	 <3d8471ca0703040741h4eff73a3wd67d648d52497e34@mail.gmail.com>
	 <200703041825.39361.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_118976_19025661.1173033186790
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2007/3/4, Andi Kleen <ak@suse.de>:

> On what hardware?

Pentium M 798 MHz -> 2GHz

> And how many frequency transitions do you have per second?

10 in a kernel compile exhibiting audio skips.

Anyway, the "Clocksource tsc unstable (delta = -263211549 ns)" line
in the dmesg I attached to the previous mail confirms IMHO that my
TSC is too unstable for scheduling purpose.

15 minutes after booting, including a kernel compile halted on the
first audio skip, I have this in
/sys/devices/system/cpu/cpu0/cpufreq/stats/trans_table

   From  :    To
         :   1995000   1596000   1330000   1064000    798000
  1995000:         0        67       101       128       367
  1596000:        20         0         3         3        41
  1330000:        21         0         0        10        73
  1064000:        30         0         0         0       111
   798000:       592         0         0         0         0

Nothing alarming I presume.

Thanks.

-- 
Guillaume

------=_Part_118976_19025661.1173033186790
Content-Type: application/octet-stream; name=cpuinfo
Content-Transfer-Encoding: base64
X-Attachment-Id: f_eyvtlc6y
Content-Disposition: attachment; filename="cpuinfo"

cHJvY2Vzc29yCTogMAp2ZW5kb3JfaWQJOiBHZW51aW5lSW50ZWwKY3B1IGZhbWlseQk6IDYKbW9k
ZWwJCTogMTMKbW9kZWwgbmFtZQk6IEludGVsKFIpIFBlbnRpdW0oUikgTSBwcm9jZXNzb3IgMi4w
MEdIegpzdGVwcGluZwk6IDgKY3B1IE1IegkJOiA3OTguMDAwCmNhY2hlIHNpemUJOiAyMDQ4IEtC
CmZkaXZfYnVnCTogbm8KaGx0X2J1ZwkJOiBubwpmMDBmX2J1Zwk6IG5vCmNvbWFfYnVnCTogbm8K
ZnB1CQk6IHllcwpmcHVfZXhjZXB0aW9uCTogeWVzCmNwdWlkIGxldmVsCTogMgp3cAkJOiB5ZXMK
ZmxhZ3MJCTogZnB1IHZtZSBkZSBwc2UgdHNjIG1zciBwYWUgbWNlIGN4OCBhcGljIHNlcCBtdHJy
IHBnZSBtY2EgY21vdiBwYXQgY2xmbHVzaCBkdHMgYWNwaSBtbXggZnhzciBzc2Ugc3NlMiBzcyB0
bSBwYmUgZXN0IHRtMgpib2dvbWlwcwk6IDE1OTYuNjIKY2xmbHVzaCBzaXplCTogNjQKCg==
------=_Part_118976_19025661.1173033186790--
