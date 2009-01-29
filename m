Return-Path: <linux-kernel-owner+w=401wt.eu-S1759238AbZA2Pl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238AbZA2Pl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 10:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbZA2Plt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 10:41:49 -0500
Received: from relay1.sgi.com ([192.48.179.29]:45933 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752118AbZA2Plt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 10:41:49 -0500
Date: Thu, 29 Jan 2009 09:41:46 -0600
From: Jack Steiner <steiner@sgi.com>
To: suresh.b.siddha@intel.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Possible x2apic breakage
Message-ID: <20090129154146.GA2694@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh -

This popped up in Ingo's x86 tree yesterday. This appears to be breaking
on our simulator running in x2apic mode. If I understand the code,
this is a real breakage and not a problem in our simulator:


arch/x86/include/asm/genapic.h

	static inline unsigned int read_apic_id(void)
	{
        	unsigned int reg;

        	reg = *(u32 *)(APIC_BASE + APIC_ID);
        	return apic->get_apic_id(reg);
	}


As expected, the failure occurs right after:

	Enabling x2apic
	Enabled x2apic and interrupt-remapping

The next reference to apicid tries to read from mem instead of MSRs.


--- jack

