Return-Path: <linux-kernel-owner+w=401wt.eu-S2993190AbXEBWNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993190AbXEBWNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993199AbXEBWNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:13:14 -0400
Received: from ns1.suse.de ([195.135.220.2]:43202 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993190AbXEBWNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:13:12 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Chandramouli Narayanan <mouli@linux.intel.com>
Subject: Re: [PATCH 2.6.21 2/3] x86_64: EFI64 support
Date: Wed, 2 May 2007 22:55:37 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20070501185945.237601000@em64tdvp.jf.intel.com> <20070501190110.958988000@em64tdvp.jf.intel.com>
In-Reply-To: <20070501190110.958988000@em64tdvp.jf.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705022255.37791.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>  		if (type && ei->type != type) 
> @@ -148,6 +178,29 @@ int __init e820_all_mapped(unsigned long
>  unsigned long __init find_e820_area(unsigned long start, unsigned long end, unsigned size) 
>  { 
>  	int i; 
> +	if (efi_enabled) {
> +		efi_memory_desc_t *md;

Please convert the memory map from EFI into the e820 map in one place. This
would avoid all these weird special cases. Also custom memory map would
just work then.

I know i386 doesn't do it this way, but it's wrong and we'll eventually
fix it there too.

Also you have a few arbitary and white space changes in there that should be removed.

-Andi
