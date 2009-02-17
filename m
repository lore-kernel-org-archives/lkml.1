Return-Path: <linux-kernel-owner+w=401wt.eu-S1752579AbZBQPH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbZBQPH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 10:07:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbZBQPHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 10:07:50 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:51926 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZBQPHt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 10:07:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Xc1e4ND09BmoAqmjxkr+Xr+EJ9ZkRSEEAc+OupRuPSZ0cLvsxQ4b9BMsxqzFIiSpQt
         3oaKSriUh5pTz2JTKtJI+x2ei3vKwntLZaTq315iT/xx4i8n3+Dl2N3WuwS3tMjDVCgU
         +MOI5E1UzPw/ImHOlMNPm/w/w7nLznCn5QGtc=
MIME-Version: 1.0
In-Reply-To: <gncm7q$gp8$1@ger.gmane.org>
References: <gncm7q$gp8$1@ger.gmane.org>
Date: Tue, 17 Feb 2009 16:07:46 +0100
Message-ID: <25e057c00902170707h3fa82669oc22ad534c340e48f@mail.gmail.com>
Subject: Re: &&//|| typo ?
From: roel kluin <roel.kluin@gmail.com>
To: =?ISO-8859-1?Q?J=F6rg=2DVolker_Peetz?= <jvpeetz@web.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/16 Jörg-Volker Peetz <jvpeetz@web.de>:
> Hi,
>
> inspired by the mail http://lkml.org/lkml/2009/2/15/159
> I did
>
> grep -Ern '\!=.*\|\|.*\!=' linux-2.6.28.5
>
> and found the following tests which are always true if the tested variable is
> not NaN:

> linux-2.6.28.5/arch/x86/kvm/vmx.c:1794: if ((ss.type != 3) || (ss.type != 7))
> linux-2.6.28.5/arch/x86/kvm/vmx.c:1837: if ((tr.type != 3) || (tr.type != 11))
> /* TODO: Check if guest is in IA32e mode */

Ok, I sent a patch

> linux-2.6.28.5/net/sunrpc/auth_unix.c:122:      if (cred->uc_uid != acred->uid ||
> cred->uc_gid != acred->gid)
>
> linux-2.6.28.5/net/sunrpc/svcauth_unix.c:747:   if (svc_getu32(argv) !=
> htonl(RPC_AUTH_NULL) || svc_getu32(argv) != 0) {
> linux-2.6.28.5/net/sunrpc/svcauth_unix.c:833:   if (svc_getu32(argv) !=
> htonl(RPC_AUTH_NULL) || svc_getu32(argv) != 0) {
>
> linux-2.6.28.5/net/sunrpc/auth_gss/gss_krb5_seqnum.c:78:        if ((plain[4] !=
> plain[5]) || (plain[4] != plain[6])
> linux-2.6.28.5/net/sunrpc/auth_gss/gss_krb5_seqnum.c:79:                                   || (plain[4] !=
> plain[7]))

I don't think this is a bug, this tests whether all are the same.

> linux-2.6.28.5/drivers/block/paride/pf.c:569:           if ((buf[k + offs] != 0x20) ||
> (buf[k + offs] != l))

I am not sure this is a bug: l can become 0x20.

> linux-2.6.28.5/drivers/block/paride/pg.c:425:           if (c != ' ' || c != l)

also c can become ' '

> linux-2.6.28.5/drivers/block/paride/pt.c:506:           if ((buf[k + offs] != 0x20) ||
> (buf[k + offs] != l))

again

> linux-2.6.28.5/drivers/misc/sgi-gru/grukservices.c:612: if (word0 != word1 ||
> word0 != MAGIC) {

Not sure either.

>
> linux-2.6.28.5/drivers/scsi/gvp11.c:283:        if (qq != q || qq != 0xff)      /* should be
> read only, all 1's */

again


> linux-2.6.28.5/drivers/scsi/FlashPoint.c:6045:                          if(bit_cnt != 0 || bit_cnt != 8)

I also spotted this but it's in comment and a pretty old driver, so I
didn't bother.
