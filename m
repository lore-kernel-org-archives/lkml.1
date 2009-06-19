Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105AbZFSGeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbZFSGeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 02:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZFSGeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 02:34:37 -0400
Received: from ozlabs.org ([203.10.76.45]:52053 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbZFSGeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 02:34:36 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: module version magic and arches with symbol prefixes
Date: Fri, 19 Jun 2009 15:08:05 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Robin Getz <rgetz@blackfin.uclinux.org>
References: <8bd0f97a0906180824y17a00110i57565aee16207e5@mail.gmail.com>
In-Reply-To: <8bd0f97a0906180824y17a00110i57565aee16207e5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906191508.06537.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Jun 2009 12:54:44 am Mike Frysinger wrote:
> the current check_modstruct_version() does this:
> {
>     const unsigned long *crc;
>
>     if (!find_symbol("module_layout", NULL, &crc, true, false))
>         BUG();
>     return check_version(sechdrs, versindex, "module_layout", mod, crc);
> }
> the trouble here is that it looks for a literal "module_layout" symbol
> and for ports that have symbol prefixes (a quick check shows Blackfin
> & h8300), this aint going to work.

MODULE_SYMBOL_PREFIX is the fix for this, ie:

	if (!find_symbol(MODULE_SYMBOL_PREFIX "module_layout), ...

> also, using BUG() here seems pretty damn harsh.  wouldnt it make more
> sense to do something like:
>     if (WARN_ON(!find_symbol("module_layout", NULL, &crc, true, false)))
>         return 0;
> this way the module is simply not loaded rather than killing the kernel

No, it means the kernel didn't build properly.  Better to fail spectacularly: 
ideally we'd do this find in an init routine and guarantee a boot crash.

Thanks,
Rusty.
