Return-Path: <linux-kernel-owner+w=401wt.eu-S1754427AbZEQUKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbZEQUKg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 16:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbZEQUKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 16:10:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51299 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbZEQUKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 16:10:24 -0400
Message-ID: <4A106F2E.4010601@redhat.com>
Date: Sun, 17 May 2009 23:10:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [KVM PATCH v2 2/4] kvm: add return value to kvm_io_bus_register_dev
References: <20090515162047.26209.93545.stgit@dev.haskins.net> <20090515162813.26209.49515.stgit@dev.haskins.net>
In-Reply-To: <20090515162813.26209.49515.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Today this function returns void and will internally BUG_ON if it fails.
> We want to create dynamic MMIO/PIO entries driven from userspace later in
> the series, so enhance this API to return an error code on failure.
>
> We also fix up all the callsites to check the return code and BUG_ON if
> it fails.
>
> The net result should be identical behavior both before and after this
> patch.  We are simply laying the groundwork for the dynamic usage
>   

What happens if the dynamic user gets in there first, then the internal 
device (which is set up by userspace)?  We'll just BUG().

Need to handle the failure gracefully, more or less.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

