Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab0BBHIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:08:01 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:52063 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab0BBHH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:07:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=BVcxfwcDt0WdQnhfPxTBBsXa1hVGKjZxAH/SJgGGcmWjXRL03JF6FxIat3pdqMsCsW
         HXD9ACdSa2fbmgYoSD1qdvBOiIKLkjpgN0jAwYEV8zYicht8IljYYC0hiC3iX8J2krMR
         mR2jToghWIk2hzyzKWemYDBL6bLIWqg83XHv4=
Date: Tue, 2 Feb 2010 08:07:51 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: zhiyi <zhuang@cs.otago.ac.nz>
Cc: linux-kernel@vger.kernel.org, Zhiyi Huang <hzy@cs.otago.ac.nz>,
       jkmair@cs.otago.ac.nz
Subject: Re: nr_cpu_ids incorrect on AMD Quad-Core Opteron 8380
Message-ID: <20100202070751.GA11623@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	zhiyi <zhuang@cs.otago.ac.nz>, linux-kernel@vger.kernel.org,
	Zhiyi Huang <hzy@cs.otago.ac.nz>, jkmair@cs.otago.ac.nz
References: <A1D71FDC-3176-4792-83ED-3ACAA3D61CFF@cs.otago.ac.nz>
 <20100130171804.GA2348@liondog.tnic>
 <AD1C7BB3-C3E6-47EC-809F-4CE3C049D92C@cs.otago.ac.nz>
 <9ea470501002010557o45bad81cp5d9ac3d19318bffe@mail.gmail.com>
 <9ea470501002010704m15dfaedau813b7accfd1d22ff@mail.gmail.com>
 <4086DEE4-5D26-4EED-8353-2C4F54238CAE@cs.otago.ac.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4086DEE4-5D26-4EED-8353-2C4F54238CAE@cs.otago.ac.nz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 01:49:06PM +1300, zhiyi wrote:
> The dmesg relevant to nr_cpu_ids of the quad socket is:
> 
> [    0.000000] NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:32 nr_node_ids:4
> 

No, this is not the relevant info. I was actually looking for the MADT ACPI
table and whether there are disabled entries like so:

[    0.000000] ACPI: LAPIC (acpi-id[0x03] lapic-id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi-id[0x04] lapic-id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi-id[0x05] lapic-id[0x84] disabled)
[    0.000000] ACPI: LAPIC (acpi-id[0x06] lapic-id[0x85] disabled)

because if there are, nr_cpu_ids will include those when you don't boot
with "possible_cpus=N".

Anyhow, you can read this for more info: http://www.pubbs.net/kernel/200912/64310/

-- 
Regards/Gruss,
    Boris.
