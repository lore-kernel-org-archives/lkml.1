Return-Path: <linux-kernel-owner+w=401wt.eu-S1752867AbZKDIbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbZKDIbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 03:31:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbZKDIba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 03:31:30 -0500
Received: from ozlabs.org ([203.10.76.45]:52488 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbZKDIba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 03:31:30 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [PATCH 09/10] module: speed up find_symbol() using binary search on the builtin symbol tables
Date: Wed, 4 Nov 2009 19:01:26 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: greg@kroah.com, linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com> <1257242782-10496-10-git-send-email-alan-jenkins@tuffmail.co.uk>
In-Reply-To: <1257242782-10496-10-git-send-email-alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911041901.26722.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Nov 2009 08:36:21 pm Alan Jenkins wrote:
> +	for (type = 0; type < EXPORT_TYPE_MAX; type++) {
> +		sym = bsearch(name, ksymtab[type].syms, ksymtab[type].num_syms,
> +			      sizeof(struct kernel_symbol), symbol_compare);

One minor point: Prefer ARRAY_SIZE() here to EXPORT_TYPE_MAX.

It'd be cool if bsearch was typesafe, but that would freak out the Old School
kernel hackers :)

> +	for (type = 0; type < EXPORT_TYPE_MAX; type++) {
> +		for (i = 0; i < symtab[type].num_syms; i++) {
> +			sym = &symtab[type].syms[i];

Same.

Thanks!
Rusty.
