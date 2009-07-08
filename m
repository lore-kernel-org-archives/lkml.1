Return-Path: <linux-kernel-owner+w=401wt.eu-S1758957AbZGHAk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957AbZGHAk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 20:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755882AbZGHAkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 20:40:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:38014 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227AbZGHAkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 20:40:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XvoZFBJNeVmY+6//wCKK10z82PMX01qrMDibvefehnP1N8Ca6NcmsSHC6T86JBOsqg
         kcOveyC4zZ+EMrWTk+7e7wdTEuJrfQ45mB7KYkOMC8LXU7M1t1c2DfVfcOmS6RclbEK8
         IS590//K3s8a4IWmeio4WbTaHddYuPbk+yWqw=
Subject: Re: [PATCH] vmalloc.c: fix double error checking
From: "Figo.zhang" <figo1802@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4A53E602.6030505@kernel.org>
References: <1246983201.2597.13.camel@myhost>  <4A53E602.6030505@kernel.org>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 08:40:06 +0800
Message-Id: <1247013611.2597.22.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-08 at 09:19 +0900, Tejun Heo wrote:
> Figo.zhang wrote:
> > it is no need for double error checking.
> > 
> > Signed-off-by: Figo.zhang <figo1802@gmail.com>
> > -		err = vmap_pud_range(pgd, addr, next, prot, pages, &nr);
> > -		if (err)
> > -			break;
> > +		if (vmap_pud_range(pgd, addr, next, prot, pages, &nr))
> > +			return -ENOMEM;
> 
> Wouldn't it be better to keep the error return value?

see the vmap_pud_range(), if suceed return 0, if error return "-ENOMEM",
so it had better use clearly logic if error directly return "-EOMEM",
avoid double checking.

Best,
Figo.zhang


> 
> Thanks.
> 
> --
> tejun

