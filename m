Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbYEECPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbYEECPZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 22:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbYEECPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 22:15:11 -0400
Received: from uki.us.mooball.net ([66.98.178.13]:49208 "EHLO
	uki.us.mooball.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbYEECPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 22:15:10 -0400
X-ClientAddr: 220.233.82.121
Subject: Re: [PATCH 13/56] microblaze_v2: PVR support, cpuinfo support
From: John Williams <john.williams@petalogix.com>
To: monstr@seznam.cz
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
In-Reply-To: <694451053534fea7b78fb9d618b53a2b5ebeb602.1209897266.git.monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
	 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
	 <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu>
	 <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>
	 <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
	 <ed3695121faf485d491cecdd96d5d4dcc498411d.1209897266.git.monstr@monstr.eu>
	 <0674b1f7abb9a3d564b68c95bc28adc2c2fe9551.1209897266.git.monstr@monstr.eu>
	 <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>
	 <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu>
	 <2f801c33caee22e112af51ae927c264ce99ead01.1209897266.git.monstr@monstr.eu>
	 <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu>
	 <0873f3a1f3b72591735c6461b51964693cac52e5.1209897266.git.monstr@monstr.eu>
	 <0ba1f259d3c17eba54e334622493577493f5065f.1209897266.git.monstr@monstr.eu>
	 <694451053534fea7b78fb9d618b53a2b5ebeb602.1209897266.git.monstr@monstr.eu>
Content-Type: text/plain
Organization: PetaLogix
Date: Mon, 05 May 2008 12:14:23 +1000
Message-Id: <1209953663.5798.61.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
X-Mooball.com-MailScanner-Information: Please contact the ISP for more information
X-Mooball.com-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailScanner-From: john.williams@petalogix.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +int cpu_has_pvr(void)
> +{
> +	unsigned flags;
> +	unsigned pvr0;
> +	int ret = 0;
> +
> +	local_irq_save(flags);
> +

...

> +out:
> +	local_irq_restore(flags);
> +	return ret;
> +}

The actual IRQ clear/restore is not required - can you just use
local_save_flags() or similar to read the MSR?


