Return-Path: <linux-kernel-owner+w=401wt.eu-S1759769AbZDRXit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759769AbZDRXit (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 19:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755990AbZDRXij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 19:38:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:3726 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879AbZDRXih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 19:38:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=LIng1NlV9mkR93CM+cdnyCq6KkV2AoewLqJ+IEiAnhnW37JxfIYLYkYqEi22e84ZtU
         yu+t8Gkw6QmhPg0SfPhAggjDmFTs5ku1RQOeqdkZDeKVE/hw5EaEu8cD4kRE4OjDLM8a
         NaDELRdcNpv1ihpEDfB5vn9RdSOY2K4AcHosc=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ben Nizette <bn@niasdigital.com>
Subject: Re: [PATCH 0/9] Fix unsafe disable_irq usage
Date: Sat, 18 Apr 2009 16:38:30 -0700
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-170.2.56.fc10.x86_64; KDE/4.2.1; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, dan.j.williams@intel.com,
       Eric Miao <eric.miao@marvell.com>, linux@arm.linux.org.uk,
       p_gortmaker@yahoo.com, David Brownell <david-b@pacbell.net>,
       sameo@linux.intel.com, linux-omap@vger.kernel.org, pierre@ossman.eu,
       linux-input@vger.kernel.org
References: <1239861245.29831.113.camel@linux-51e8.site>
In-Reply-To: <1239861245.29831.113.camel@linux-51e8.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904181638.30794.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Wednesday 15 April 2009 22:54:05 Ben Nizette wrote:
> After being bitten by unsafe usage of disable_irq from within that irq's
> handler [1], I went through and used Coccinelle to audit the rest of
> drivers/ too.  This turned up 9 more unsafe usages.
>
> As Haavard pointed out in that thread, disable_irq waits for running
> handlers of an irq to complete before returning.  When a handler
> disable_irq's its own irq then we see a deadlock.
>
> Note that this wasn't actually observed in the wild until the recent
> merge of
>
> commit 3aa551c9b4c40018f0e261a178e3d25478dc04a9
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Mon Mar 23 18:28:15 2009 +0100
>
>     genirq: add threaded interrupt handler support
>
>     Add support for threaded interrupt handlers
>
>

Applied all 4 patches affecting input devices, they should show up next
time Linus pulls from me. Thank you.

-- 
Dmitry
