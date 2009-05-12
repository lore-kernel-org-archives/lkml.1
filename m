Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932AbZELRDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbZELRDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 13:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbZELRCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 13:02:52 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:52695 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZELRCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 13:02:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iBytqgwUmEc0uMLxxq1xHwujCjbiXleGUGAl+SBPKxEzPyuIgWSwXZgkV9Lz72hklw
         U5bZrIIQIEnAeIShHh6clKCasMtM50ToNLl4N6c9FnYfLWQBq6yIa/xHnF+0R5JldVoI
         sS7s3V4g8GlcTovBGBfHiw1KwdvHI4C+0MB2w=
Date: Tue, 12 May 2009 21:02:46 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       eswierk@aristanetworks.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/numa] x86: read apic ID in the !acpi_lapic case
Message-ID: <20090512170246.GB12820@lenovo>
References: <49FC85A9.2070702@kernel.org> <tip-4797f6b021a3fa399942245d07a1feb30df81bb8@git.kernel.org> <20090512112205.GA12108@elte.hu> <20090512145128.GA10220@lenovo> <20090512145808.GA20587@elte.hu> <4A099013.6040708@kernel.org> <20090512150631.GA32067@elte.hu> <20090512164617.GA21673@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090512164617.GA21673@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Tue, May 12, 2009 at 06:46:17PM +0200]
| 
| got this on a testbox:
| 
| [    0.113333] WARNING: at arch/x86/kernel/apic/apic.c:253 warn_slowpath_null+0x28/0x50()
| 
| 	Ingo
|

It's expected (unfortunately). If we have SMP compiled kernel
we still rely on apic_read heavily. Since for fake'ed apic
we just return 0 for any reading I suspect we could just drop
WARN_ON_ONCE for native_apic_read_dummy. Yinghai?

(well, actually we should clean up callees but it would require
 some effort)
 
	-- Cyrill
