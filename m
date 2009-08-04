Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbZHDLUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbZHDLUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 07:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbZHDLUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 07:20:52 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:53961 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbZHDLUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 07:20:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=soYbXurvqXTuJhFv2qjPl+7H0iMdKcWaUAeNv8bAMRV9cSQhv9fiHJW0OCcltagvrs
         wE55p56jJ9th3X5xOcqi2+iDvPbovS2OwPSGP+4ADcq08p87WJaZKUgPGsJgrO+UnT/O
         KlkQ/QOvfGzwvsKThOE9A+OB/03FAuZIiHu6A=
MIME-Version: 1.0
In-Reply-To: <4A780FE6.9050704@inria.fr>
References: <c384c5ea0908030823y494ee8bei85aa62c1470fa3ec@mail.gmail.com>
	 <Pine.LNX.4.64.0908031724200.2296@sister.anvils>
	 <4A77FCFB.9020001@inria.fr>
	 <c384c5ea0908040259k4295c986wdd45fe9e1e4315b1@mail.gmail.com>
	 <4A780FE6.9050704@inria.fr>
Date: Tue, 4 Aug 2009 13:20:50 +0200
Message-ID: <c384c5ea0908040420v431fd075hd053f36c232d5966@mail.gmail.com>
Subject: Re: [PATCH] mm: get_user_pages() stores ERR_PTR() in pages[i] on 
	failure
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n74BL97T023182

Hello Brice,
On Tue, Aug 4, 2009 at 12:39 PM, Brice Goglin<Brice.Goglin@inria.fr> wrote:>> Only compile-tested (and not in the nommu case).>> @@ -1317,10 +1320,11 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,>                                        FAULT_FLAG_WRITE : 0);>>                                if (ret & VM_FAULT_ERROR) {> -                                       if (ret & VM_FAULT_OOM)> -                                               return i ? i : -ENOMEM;> -                                       else if (ret & VM_FAULT_SIGBUS)> -                                               return i ? i : -EFAULT;> +                                       if (ret & VM_FAULT_OOM) {> +                                               err = -ENOMEM;> +                                               goto abort;> +                                       } else if (ret & VM_FAULT_SIGBUS)> +                                               goto abort;
Minor style issue; when the if-block has brackets, the else(if)-blockshould also have brackets (even when it's a one-liner on the elseblock).
Looks good, I will go ahead and test it (back-port/patched against 2.6.30).
Regards,-- Leonÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
