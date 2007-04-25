Return-Path: <linux-kernel-owner+w=401wt.eu-S2992721AbXDYM7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992721AbXDYM7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 08:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992730AbXDYM7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 08:59:16 -0400
Received: from ns.oss.ntt.co.jp ([222.151.198.98]:47313 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992721AbXDYM7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 08:59:15 -0400
Subject: Re: [PATCH 1/10] safe_apic_wait_icr_idle - i386
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Keith Owens <kaos@ocs.com.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, horms@verge.net.au,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org, ak@suse.de,
       vgoyal@in.ibm.com, mbligh@google.com, akpm@linux-foundation.org
In-Reply-To: <15716.1177505701@ocs3.ocs.com.au>
References: <15716.1177505701@ocs3.ocs.com.au>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Wed, 25 Apr 2007 21:59:14 +0900
Message-Id: <1177505954.19745.22.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-25 at 22:55 +1000, Keith Owens wrote:
> Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao (on Wed, 25 Apr 2007 20:13:28 +0900) wrote:
> >+static __inline__ unsigned long safe_apic_wait_icr_idle(void)
> >+{
> >+	unsigned long send_status;
> >+	int timeout;
> >+
> >+	timeout = 0;
> >+	do {
> >+		udelay(100);
> >+		send_status = apic_read(APIC_ICR) & APIC_ICR_BUSY;
> >+	} while (send_status && (timeout++ < 1000));
> >+
> >+	return send_status;
> >+}
> >+
> 
> safe_apic_wait_icr_idle() as coded guarantees a minimum 100 usec delay
> before sending the IPI, this extra delay is unnecessary.  Change it to
Hi Keith,

Thank you for the feedback!

> 	do {
> 		send_status = apic_read(APIC_ICR) & APIC_ICR_BUSY;
> 		if (send_status)
> 			break;
> 		udelay(100);
> 	} while (timeout++ < 1000);
Oops, that is a good point. I will resend this patch either tonight or
tomorrow morning.

