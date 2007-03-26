Return-Path: <linux-kernel-owner+w=401wt.eu-S964959AbXCZKBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964959AbXCZKBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 06:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965131AbXCZKBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 06:01:38 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:49857 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964852AbXCZKBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 06:01:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=aRs/K16X80NpLD8sGQ/XjtWHHqRH0EV/yeEzod7nDCnp81i82bx9L1sXiLIr9WOgjYw6F1Xr0udSU5l+8aFFU9JLV4nv2Yt2ETplJtnx+IROfzKxcieZ5pFKpp/ZF8PpU/PRVY2Y/Fa5QwjwUMa5tf3y6fnqHnGw1pvf/WY6l/I=
Message-ID: <460799F6.5080508@gmail.com>
Date: Mon, 26 Mar 2007 19:01:26 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?UTF-8?B?TWF0?= =?UTF-8?B?aGlldSBCw6lyYXJk?= 
	<Mathieu.Berard@crans.org>,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       Fabio Comolli <fabio.comolli@gmail.com>,
       Plamen Petrov <plamen.petrov@tk.ru.acad.bg>,
       Laurent Riffard <laurent.riffard@free.fr>,
       Lukas Hejtmanek <xhejtman@mail.muni.cz>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [2/5] 2.6.21-rc4: known regressions (v2)
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070323184828.GP752@stusta.de>
In-Reply-To: <20070323184828.GP752@stusta.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Subject    : NCQ problem with ahci and Hitachi drive  (ACPI related)
> References : http://lkml.org/lkml/2007/3/4/178
>              http://lkml.org/lkml/2007/3/9/475
> Submitter  : Mathieu Bérard <Mathieu.Berard@crans.org>
> Handled-By : Tejun Heo <htejun@gmail.com>
> Status     : problem is being debugged

Patch is available and whether to put it into mainline or not is being
discussed.  libata EH does the right thing after several errors so
things should work properly after several errors.

http://thread.gmane.org/gmane.linux.kernel/496524

> Subject    : libata: PATA UDMA/100 configured as UDMA/33
> References : http://lkml.org/lkml/2007/2/20/294
>              http://www.mail-archive.com/linux-ide@vger.kernel.org/msg04115.html
>              http://bugzilla.kernel.org/show_bug.cgi?id=8133
>              http://bugzilla.kernel.org/show_bug.cgi?id=8164
>              http://lkml.org/lkml/2007/3/21/330
> Submitter  : Fabio Comolli <fabio.comolli@gmail.com>
>              Plamen Petrov <plamen.petrov@tk.ru.acad.bg>
>              Laurent Riffard <laurent.riffard@free.fr>
>              Lukas Hejtmanek <xhejtman@mail.muni.cz>
> Handled-By : Tejun Heo <htejun@gmail.com>
>              Alan Cox <alan@lxorguk.ukuu.org.uk>
> Status     : Alan: Some cases should be fixed now but probably not all
>                    (eg the Nvidia one)

Further patch submitted.

http://thread.gmane.org/gmane.linux.ide/17444

This should fix all regression cases.  sata_nv has been always broken so
isn't a regression.  It needs acpi tricks and I don't think it fits
2.6.21 cycle.

Thanks.

-- 
tejun
