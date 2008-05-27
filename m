Return-Path: <linux-kernel-owner+w=401wt.eu-S1760149AbYE0Wkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760149AbYE0Wkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 18:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757308AbYE0WkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 18:40:25 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:18277 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178AbYE0WkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 18:40:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=X2UYiKX0+lHwdUfsLbJEM3sIfg8+AvtGhfxErhG/1NYHiSvc+38tPfSL0UtEPmFvL/zN2YJeeERK1S3sF13oTl9ykaoO73r+D5+jQr0qfCUOL8x+SjAMM/x650TvwzY/k5oStjcAi/Pubamwr1nvgc/gFdtVpBv6XT4xBXMNjlY=
Subject: Re: [PATCH 2/2] byteorder: eliminate pointer bytorder api
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.1.10.0805261416370.19084@fbirervta.pbzchgretzou.qr>
References: <1211311449.5915.195.camel@brick>
	 <20080520.141731.99514303.davem@davemloft.net>
	 <1211321725.5915.208.camel@brick>
	 <20080520.151951.239145609.davem@davemloft.net>
	 <1211322619.5915.218.camel@brick>
	 <alpine.LNX.1.10.0805261416370.19084@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Tue, 27 May 2008 15:40:16 -0700
Message-Id: <1211928016.5964.6.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-26 at 14:17 +0200, Jan Engelhardt wrote:
> On Wednesday 2008-05-21 00:30, Harvey Harrison wrote:
> >On Tue, 2008-05-20 at 15:19 -0700, David Miller wrote:
> >> From: Harvey Harrison <harvey.harrison@gmail.com>
> >> Date: Tue, 20 May 2008 15:15:25 -0700
> >> 
> >> > Obviously I missed that part, my apologies.  Would it be acceptable if,
> >> > taking the possibly arch-specific parts, moved the [endian]_to_cpup
> >> > name over to get_[endian]
> >> 
> >> Why are we fiddling with interface names that have been fine for about
> >> 10 years?
> 
> I suggest some comments be added to the cpu_to_*p() to specify their 
> reason for being there (namely, speedups on some CPUs)

Agreed.

> 
> >Saw a lot of (or similar in a private helper):
> >
> >*(__be32 *)ptr = cpu_to_be32(val);
> >
> >So I came up with
> >
> >void put_be32(val, ptr);
> 
> I think it would be better to follow the common notation of the target 
> being on the left side (like most intel asm commands and things like 
> C's memcpy, etc)

I based this on the existing put_unaligned_be32 to have the same arg
order.

Cheers,

Harvey

