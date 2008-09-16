Return-Path: <linux-kernel-owner+w=401wt.eu-S1753146AbYIPKNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbYIPKNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 06:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbYIPKNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 06:13:16 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:3049 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbYIPKNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 06:13:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UCjWt8eEB6Ha/wW3rTSOJKFvwFV11XfM3M50D+oaE6hyfRR0jyq++a9d1vLSRm8lrM
         lWY8mVpUhurn4QgFBaE0gy3O+sD9bdZ+/Mu+yfCKfV6JT5I0E3Z2OmZaNxDOSKVGGsDX
         iT9Oh1v21S+kPuF+2K8F34P6TJzY5aESpLL/4=
Date: Tue, 16 Sep 2008 14:13:11 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] apci: dump slit v3
Message-ID: <20080916101311.GB7187@lenovo>
References: <1221555174-30060-1-git-send-email-yhlu.kernel@gmail.com> <1221555174-30060-5-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221555174-30060-5-git-send-email-yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Yinghai Lu - Tue, Sep 16, 2008 at 01:52:54AM -0700]
| v2: using boot_printk
| v3: using acpi_printk
| 
| Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
| 
| ---
|  drivers/acpi/numa.c |    8 ++++++++
|  1 file changed, 8 insertions(+)
| 
| Index: linux-2.6/drivers/acpi/numa.c
| ===================================================================
| --- linux-2.6.orig/drivers/acpi/numa.c
| +++ linux-2.6/drivers/acpi/numa.c
| @@ -150,6 +150,14 @@ static __init int slit_valid(struct acpi
|  {
|  	int i, j;
|  	int d = slit->locality_count;
| +	acpi_printk(KERN_LOG_DEBUG, KERN_DEBUG "ACPI: SLIT: nodes = %d\n", d);
| +	for (i = 0; i < d; i++) {
| +		for (j = 0; j < d; j++)  {
| +			u8 val = slit->entry[d*i + j];
| +			acpi_printk(KERN_LOG_DEBUG, " %d", val);
| +		}
| +		acpi_printk(KERN_LOG_DEBUG, "\n");
| +	}
|  	for (i = 0; i < d; i++) {
|  		for (j = 0; j < d; j++)  {
|  			u8 val = slit->entry[d*i + j];
| 

I suppose there will be some apic_pr_... macro since
typing ~40 symbols to print a message a bit annoying.
Yinghai?

		- Cyrill -
