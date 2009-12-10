Return-Path: <linux-kernel-owner+w=401wt.eu-S934386AbZLJME0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934386AbZLJME0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 07:04:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934190AbZLJMEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 07:04:20 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:53250 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934188AbZLJMET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 07:04:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OnKxOLWHFS9e5iCFVge+k69Fv6MjSGPjqehpJwJPISDAvQKM2SKStS95buj0z/srDg
         fNx3VKWmmnTxyp1um5coAKFyQbuKJ4/imFukW5+H1CtJRFsf7HmansiYtEualH0PcdtJ
         +SSpVGiIGGCLFELNyrK1AsDbRLd6sJVZm2Lr4=
MIME-Version: 1.0
In-Reply-To: <200912090728.10135.a.miskiewicz@gmail.com>
References: <1260276751-19501-1-git-send-email-mmarek@suse.cz>
	 <4B1EB5E9.3010506@suse.cz>
	 <9b2db90b0912082222x5287d452pf9e55d6ff44e511c@mail.gmail.com>
	 <200912090728.10135.a.miskiewicz@gmail.com>
Date: Thu, 10 Dec 2009 14:04:23 +0200
Message-ID: <9b2db90b0912100404s5e97d9ddk181aed1990e36208@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: new kbuild maintainer
From: Nir Tzachar <nir.tzachar@gmail.com>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> On my disto it works but it won't on a distro where /usr/include/ncurses
> contains wide version of headers.

ncurses does not support a proper pkg-config scheme, hence the
difficulty with finding the correct flags. Regarding the wideness of
the library, I would presume that any distro which mismatches
/usr/include/ncurses.h and libncurses.so is in itself broken. Taking
this into consideration, I think that including /usr/include/ncurses.h
and linking against -lncurses should work. We should entirely ignore
the wide version of the library, and use the default installation
provided.

>
>>
>> Moreover, currently nconfig does not use this check.
>
> I was testing on linus git and this flags from this check were used in nconfig
> build, too (that's why there were ncurses and ncursesw at the same time in
> linking command).

Well, I do not know why, by the check changed the flags for _all_
targets in the scripts/kconfig dir, such that even qconfig got copiled
with -lncursesw. Strange. The change I made in the Makefile in the
previous mail fixes that.

Cheers,
Nir.
