Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbZCEPUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbZCEPUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 10:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbZCEPUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 10:20:04 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:51779 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbZCEPUB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 10:20:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=egQl/f+8Dx4nfQ0Wk5y6BWhQYuFG8Cnftzb3QeiEiLm5J2cfYFHf8j+WVyI/Jkgg/K
         NU2FhGAK2OCoarxycj4fh3dqQrz8JsdRuuFVT6wGTVTIDP7ZDJqgeghykttvjFZSsm+6
         8CQz2VzE40Sc1WNWKyPkt8TGLMHslZpTbhpRA=
MIME-Version: 1.0
Reply-To: petkovbb@gmail.com
In-Reply-To: <200903051549.22518.bzolnier@gmail.com>
References: <1236158216-23052-1-git-send-email-petkovbb@gmail.com>
	 <200903051312.29784.bzolnier@gmail.com>
	 <9ea470500903050553m6ab9dfa5hab340213388a4c67@mail.gmail.com>
	 <200903051549.22518.bzolnier@gmail.com>
Date: Thu, 5 Mar 2009 16:19:57 +0100
Message-ID: <9ea470500903050719m7952f84ct56475c6445846eeb@mail.gmail.com>
Subject: Re: [PATCH 3/3] ide-{cd,floppy}: do not map all cmds to an sg
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Unrelated to the original issue that the patch tries to fix
> (sg mapping no data commands which OOPS-es w/ DEBUG_VIRTUAL=y):
> - moving ide_init_sg_cmd()+ide_map_sg() to ide_issue_pc()
> - converting the code to use blk_rq_bytes()

aah, ok, now I could get exactly what you meant :). However, (!) ide-floppy is
potentially broken in the same way for data-less cmds since we unconditionally
map an rq to an sg there _too_. That was  the reason for the other changes. And
yes, I should've been more clear in the changelog.

> [ Moreover if you actually cared to write down the proper changelog
>  I'm pretty sure that you would ask yourself whether these changes
>  really belong to a bugfix patch... ]

-- 
Regards/Gruss,
Boris
