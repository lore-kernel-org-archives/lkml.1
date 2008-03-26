Return-Path: <linux-kernel-owner+w=401wt.eu-S1760981AbYCZVqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760981AbYCZVqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 17:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756612AbYCZVqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 17:46:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49192 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbYCZVqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 17:46:22 -0400
Date: Wed, 26 Mar 2008 22:49:39 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jon Tollefson <kniht@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
       Linux Memory Management List <linux-mm@kvack.org>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>,
       Adam Litke <agl@linux.vnet.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Paul Mackerras <paulus@samba.org>, npiggin@suse.de
Subject: Re: [PATCH 1/4] allow arch specific function for allocating gigantic pages
Message-ID: <20080326214939.GB29105@one.firstfloor.org>
References: <47EABE2D.7080400@linux.vnet.ibm.com> <47EABF09.6090302@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47EABF09.6090302@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Haven't reviewed it in detail, just noticed something.

> @@ -614,6 +610,7 @@ static int __init hugetlb_init(void)
>  {
>  	if (HPAGE_SHIFT == 0)
>  		return 0;
> +	INIT_LIST_HEAD(&huge_boot_pages);
>  	return hugetlb_init_hstate(&global_hstate);

I don't think adding the INIT_LIST_HEAD here is correct. There can
be huge pages added by the __setup handlers before hugetlb_init

-Andi
