Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbYFYVpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbYFYVpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 17:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbYFYVp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 17:45:28 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:52639 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbYFYVp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 17:45:27 -0400
Message-ID: <4862BCA3.8020005@keyaccess.nl>
Date: Wed, 25 Jun 2008 23:46:11 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: bjorn.helgaas@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PNP: have quirk_system_pci_resources() include io resources.
References: <4862873C.3070507@keyaccess.nl> <20080625141621.28639b58.akpm@linux-foundation.org>
In-Reply-To: <20080625141621.28639b58.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25-06-08 23:16, Andrew Morton wrote:

> On Wed, 25 Jun 2008 19:58:20 +0200
> Rene Herman <rene.herman@keyaccess.nl> wrote:
> 
>> +			unsigned int type;
>> +
>> +			type = pci_resource_flags(pdev, i) &
>> +					(IORESOURCE_IO | IORESOURCE_MEM);
> 
> pci_resource_flags() returns an unsigned long.
> 
> But I think you're right and resource.flags is wrong.  Because there's
> no way in which we'll ever be able to use bits 32-63 of that field
> anyway.
> 
> I suppose that Someone(tm) should convert resource.flags to a u32 or
> something.  Minor issue.

Yes, did notice but pnp_get_resource() then takes those same flags as an 
unsigned int -- had to pick one or the other and "the smallest one" then 
seemed best...

Rene.
