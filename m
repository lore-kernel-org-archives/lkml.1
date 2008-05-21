Return-Path: <linux-kernel-owner+w=401wt.eu-S935275AbYEUBPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935275AbYEUBPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 21:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934673AbYEUBPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 21:15:14 -0400
Received: from ozlabs.org ([203.10.76.45]:52696 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934340AbYEUBPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 21:15:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18483.30532.288389.155934@cargo.ozlabs.ibm.com>
Date: Wed, 21 May 2008 11:13:40 +1000
From: Paul Mackerras <paulus@samba.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Remove all users of cpu_to_{le|be}{16|32|64}p
In-Reply-To: <1211311449.5915.193.camel@brick>
References: <1211311449.5915.193.camel@brick>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison writes:

> @@ -602,9 +600,7 @@ static inline __hc32 cpu_to_hc32 (const struct ohci_hcd *ohci, const u32 x)
>  
>  static inline __hc32 cpu_to_hc32p (const struct ohci_hcd *ohci, const u32 *x)
>  {
> -	return big_endian_desc(ohci) ?
> -		cpu_to_be32p(x) :
> -		cpu_to_le32p(x);
> +	return big_endian_desc(ohci) ? cpu_to_be32(*x) : cpu_to_le32(*x);

Please don't do this, because it means we don't get to use the
byte-reversing loads and stores on powerpc, and end up using several
instructions instead of one.

Paul.
