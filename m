Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbZJLQIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbZJLQIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 12:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754943AbZJLQIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 12:08:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:33085 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbZJLQIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 12:08:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=GVCWP71B962mFHiMYurjQhL1PL85EdKYvTV1OUK62eO01BB1AxprsYUP56Cwq5rOa6
         /FhRKTztWbx03bgLXHFs15ysSwtpvg3YoAg6v0/HkF4XhinerbUYhVvPxLLNmGsQeno4
         7kisqblHecvzGXeMTFb9WYF6nzZVGWiTrQtXE=
Date: Tue, 13 Oct 2009 00:10:58 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch] Fix leak in usermode linux
Message-ID: <20091012161058.GB3961@hack>
References: <4AD32A14.3050408@lsexperts.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4AD32A14.3050408@lsexperts.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 03:07:32PM +0200, Eric Sesterhenn wrote:
>hi,
>
>this was spotted by cppcheck, if find_tempdir fails,
>we dont free tempname.
>
>Signed-off-by: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks!


>
>--- linux/arch/um/os-Linux/mem.c.orig	2009-10-12 15:04:28.000000000 +0200
>+++ linux/arch/um/os-Linux/mem.c	2009-10-12 15:04:37.000000000 +0200
>@@ -175,7 +175,7 @@ static int __init make_tempfile(const ch
>
> 	find_tempdir();
> 	if ((tempdir == NULL) || (strlen(tempdir) >= MAXPATHLEN))
>-		return -1;
>+		goto out;
>
> 	if (template[0] != '/')
> 		strcpy(tempname, tempdir);
>
>-- 
>LSE Leading Security Experts GmbH, Postfach 100121, 64201 Darmstadt
>Unternehmenssitz: Weiterstadt, Amtsgericht Darmstadt: HRB8649
>Geschäftsführer: Oliver Michel, Sven Walther
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
