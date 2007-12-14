Return-Path: <linux-kernel-owner+w=401wt.eu-S1763503AbXLNI43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763503AbXLNI43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 03:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbXLNI4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 03:56:22 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:23540 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751733AbXLNI4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 03:56:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=hrv56etoPZKgbwpF7soIgo1CbIs5LMgtY6L8BW07VlbtzB1NOvj3yHgM/nnKu3VNce9ifFi654do7j4l6mM2YRcy4WPoUZwWBTEu4wgJXCGXJoTprrWxK6N5ESAuNs9vt7NXQsEeqzXYUlXEakuRtWOgo7hERm4CPE0z6ysWCoE=  ;
X-YMail-OSG: j._oxyIVM1k2PuwUqKbeYwINCffm1NA.oN8UMI1JaieeJMrMCm14X4Nws4Seoosn1vJa5ILAYg--
From: David Brownell <david-b@pacbell.net>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] ohci: avoid an unused variable warning
Date: Fri, 14 Dec 2007 00:56:18 -0800
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <47610414.76E4.0078.0@novell.com>
In-Reply-To: <47610414.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712140056.18728.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 December 2007, Jan Beulich wrote:
> 
> With CONFIG_PM, but without CONFIG_PM_SLEEP, the intention of the
> conditional in ohci_pci_start() doesn't work since device_may_wakeup()
> references pdev only with the latter config option.

Yuck.  That means that runtime power management won't work correctly.

The same wakeup mechanisms that apply during SUSPEND and HIBERNATION
are also used for runtime PM(*) ... which is allowed by CONFIG_PM, and
which accordingly should not depend on PM_SLEEP.

I think the bug is that device_may_wakeup() now looks at CONFIG_PM_SLEEP
instead of just CONFIG_PM.

- Dave

(*) Although ACPI has problems with the notion of runtime PM.  For
    example, it ignores PCI PME# signaling until PM_SLEEP transitions.
