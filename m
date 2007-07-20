Return-Path: <linux-kernel-owner+w=401wt.eu-S1758240AbXGTKOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240AbXGTKOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 06:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758432AbXGTKM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 06:12:58 -0400
Received: from ik-out-1112.google.com ([66.249.90.179]:65314 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758386AbXGTKM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 06:12:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hedGDomDELrt4m9MfJ90lhjkc67YBQNiIlDU4Jj3WdTL1Kv+kt99xlptPaAYspM+ca/UuvN8/UnAWC9oGDs5jqIEAxDgOHF92Ds0kY5wgCEoGmpb+8cH7bIxIWIFqxSt8shYnajcGe+kydP7Q8sAiOuxwQ6P7vRrY4HUBZB/ufQ=
Message-ID: <91b13c310707200312j17ec110bm20c100e5861b1758@mail.gmail.com>
Date: Fri, 20 Jul 2007 18:12:53 +0800
From: "rae l" <crquan@gmail.com>
To: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: [PATCH] fs/fuse/dev.c: use zero_user_page instead
Cc: "Miklos Szeredi" <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <a8e1da0707200309n377eca1fwa640eeceb920959b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11849242706-git-send-email-crquan@gmail.com>
	 <a8e1da0707200309n377eca1fwa640eeceb920959b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, Dave Young <hidave.darkstar@gmail.com> wrote:
> > -       if (page && zeroing && count < PAGE_SIZE) {
> > -               void *mapaddr = kmap_atomic(page, KM_USER1);
> > -               memset(mapaddr, 0, PAGE_SIZE);
> > -               kunmap_atomic(mapaddr, KM_USER1);
> > -       }
> > +       if (page && zeroing && count < PAGE_SIZE)
> > +               zero_user_page(page, 0, PAGE_SIZE, KM_USER1);
> Why clear all page? IMHO,only count bytes need to be cleared.
The original one is memset(mapaddr, 0, PAGE_SIZE), namely clear the whole page.

-- 
Denis Cheng
Linux Application Developer

"One of my most productive days was throwing away 1000 lines of code."
 - Ken Thompson.
