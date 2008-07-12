Return-Path: <linux-kernel-owner+w=401wt.eu-S1756815AbYGLDQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbYGLDQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 23:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753210AbYGLDQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 23:16:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:23105 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbYGLDQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 23:16:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=L96fGncSoxiyPFw17ATRemXmzq1f+14jY2IHyKyVC3DW6nEFHFkf+plYwzi7v5PMhu
         EktAkfBtlk4NwQ/w8UvuMeT0U+rEnt4OJt6a6D3fTKr7V/f+glNAMxc9LKHTQ87Jradw
         5g5swoS57NioJTn6Yp3SLjhJnUWEbmwhxJI08=
Message-ID: <86802c440807112016k38c8161aq143463ee57b24c35@mail.gmail.com>
Date: Fri, 11 Jul 2008 20:16:03 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Suresh Siddha" <suresh.b.siddha@intel.com>
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and x2apic support
Cc: "Ingo Molnar" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "steiner@sgi.com" <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jeremy@goop.org" <jeremy@goop.org>
In-Reply-To: <86802c440807111502n9835b5fybd99ed388bb71b7d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080710181634.764954000@linux-os.sc.intel.com>
	 <20080710195320.GA23322@elte.hu>
	 <20080710215617.GM1678@linux-os.sc.intel.com>
	 <20080711102814.GA17938@elte.hu> <20080711200957.GA8173@elte.hu>
	 <20080711203151.GU1678@linux-os.sc.intel.com>
	 <86802c440807111342j5fbf21e1ibd5129718cde4e43@mail.gmail.com>
	 <20080711204521.GA15689@elte.hu>
	 <20080711212418.GV1678@linux-os.sc.intel.com>
	 <86802c440807111502n9835b5fybd99ed388bb71b7d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. wonder if x2apic can be use with uniprocessor.

in APIC_init_uniprocessor, it will try to enable x2apic, but later

apic_write(APIC_ID, SET_APIC_ID(boot_cpu_physical_apicid));

but SET_APIC_ID is still for xapic version. so need to GET_APIC_ID,
SET_APIC_ID for different
genapic like 32bit.

2 check_x2apic is called in setup_arch, but it only set apic_ops,
and genapic still not changed, aka apic_flat...
wonder if you need to call setup_apic_routing to set genapic.

otherwise read_apic_id could have use the one from apic_flat....need
to shift......

3.or move read_apic_id to apic_ops intead...together with GET_APIC_ID too.
but 32bit version seems like to put GET_APIC_ID with genapic...

which one is better? 2 or 3

YH
