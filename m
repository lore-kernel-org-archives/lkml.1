Return-Path: <linux-kernel-owner+w=401wt.eu-S1753533AbXJJNgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbXJJNgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 09:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbXJJNfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 09:35:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:6037 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbXJJNfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 09:35:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XV1sGZnmTnV94V5ErtkQuaIWdXGc3YBh4wUBxmEmHi1+Heai2LFYZ0Jd7VuvZXbLguwBIjnQOyjchFMGO/8+6ydNv+mjxwQo98qS0BChfsbE52fo8iKLROVpMokChteKXLwHn6DmrMGsLONcP+ASG/6quem2ra6yUcm8U8U7vLk=
Message-ID: <118833cc0710100635x205503a2peb73d24384538afa@mail.gmail.com>
Date: Wed, 10 Oct 2007 09:35:49 -0400
From: "Morten Welinder" <mwelinder@gmail.com>
To: "Alexey Dobriyan" <adobriyan@sw.ru>
Subject: Re: idio{,ma}tic typos (was Re: + fix-vm_can_nonlinear-check-in-sys_remap_file_pages.patch added to -mm tree)
Cc: "Al Viro" <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       davej@codemonkey.org.uk, "Pierre Ossman" <drzeus@drzeus.cx>,
       akpm@osdl.org, linux-sparse@vger.kernel.org
In-Reply-To: <20071010104540.GA6366@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071010104540.GA6366@localhost.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> While we're at it, below is somewhat ugly sparse patch for detecting
> "&& 0x" typos.

Excellent idea, and there is something to be said about a low-footprint patch
like that.  However, if you really want to capture this kind of bugs, you would
need to have some kind "not a boolean" or "bitfield" attribute that
can propagate.
For example, you would want

    if (foo && (BAR | BAZ)) ...;

with BAR and BAZ being hex constants to produce the same warning.

Incidentally, it is probably not just hex constants that deserve this treatment:
octal constants and variations of (1 << cst) are of the same nature.  As well
as enums defined in such manners.

Morten
