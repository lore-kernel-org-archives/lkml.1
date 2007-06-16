Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbXFPC2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbXFPC2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 22:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757424AbXFPC2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 22:28:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:38054 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757418AbXFPC2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 22:28:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Ly8R5RsHKdVSkaI2SuIy0mojHOpaaYhrV+JRLgfz+BMmlmJAqwkJrU/Vtls2etE6lgQP/B7IKxxkF7895Lgv5o+EuJdYNPmfWDB4ppZd6Nemfxbrx1RkqSDKhrzHbmBLHNp+TjKmpxwT05HIi/IJu5rqrCR+pyLuHzHiuOm7ljM=
Date: Sat, 16 Jun 2007 06:40:03 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] natsemi irq flags
Message-ID: <20070616024003.GA5722@martell.zuzino.mipt.ru>
References: <20070615211608.11079.35368.stgit@ghaskins-t60p.haskins.net> <46730D82.7020508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46730D82.7020508@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 06:06:58PM -0400, Chuck Ebbert wrote:
> On 06/15/2007 05:17 PM, Gregory Haskins wrote:
> > The spinlock irq flags should be a unsigned long to properly support 64 bit
> 
> Ouch. Can't we automate checking for that?

Hopefully I'll do it before next -rc1.

--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -191,6 +191,7 @@ typedef __u32 __bitwise __wsum;
 
 #ifdef __KERNEL__
 typedef unsigned __bitwise__ gfp_t;
+typedef unsigned long __bitwise__ irq_flags_t;
 
 #ifdef CONFIG_RESOURCES_64BIT
 typedef u64 resource_size_t;


803 files changed, 2651 insertions(+), 2617 deletions(-)
and counting

