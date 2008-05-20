Return-Path: <linux-kernel-owner+w=401wt.eu-S934436AbYETWPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934436AbYETWPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761059AbYETWP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:15:28 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:9752 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757635AbYETWP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:15:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=miRZyzzY12Xh8hFV1YzTlwmQUISWXjow5/2VF3mVcAh2z8N/2Z4FOGF1bJjFhjRv8UC5wAM/kU9PT1shVMDD87cMLHWBWYfMC9uShsWKolDjZ5f/LxWKLjguo2GESjH3gzubUzuT8FjE1UUr7zft8Zz210BSBzLuRiypB+Uq7lo=
Subject: Re: [PATCH 2/2] byteorder: eliminate pointer bytorder api
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080520.141731.99514303.davem@davemloft.net>
References: <1211311449.5915.195.camel@brick>
	 <20080520.141731.99514303.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 20 May 2008 15:15:25 -0700
Message-Id: <1211321725.5915.208.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-20 at 14:17 -0700, David Miller wrote:
> From: Harvey Harrison <harvey.harrison@gmail.com>
> Date: Tue, 20 May 2008 12:24:09 -0700
> 
> > Not a great api, should be using cpu_to_etc and deref the pointer yourself.
> > cpu_to_le16p
> > cpu_to_le32p
> > cpu_to_le64p
> > cpu_to_be16p
> > cpu_to_be32p
> > cpu_to_be64p
> > 
> > Replaced by the aligned get_/put_ helpers
> > le16_to_cpup
> > le32_to_cpup
> > le64_to_cpup
> > be16_to_cpup
> > be32_to_cpup
> > be64_to_cpup
> > 
> > Also add const to the get/put helpers and use them in the access_ok case for
> > unaligned access.
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> 
> But what you're doing in the first patch is killing performance for some
> cases.
> 
> The reason we use the cpu_to_*p() interfaces is to get the other-endian
> load and store instructions some processors have.
> 
> What you're doing is undoing all of that work we've done to take
> advantage of such things.

Obviously I missed that part, my apologies.  Would it be acceptable if,
taking the possibly arch-specific parts, moved the [endian]_to_cpup
name over to get_[endian]

ie:

le16_to_cpup -> get_le16

I'd leave cpu_to_le16p alone (it's not used that much anyway).

To make it similar to the get_unaligned_le16 helpers?

Thanks for having a look,

Harvey

