Return-Path: <linux-kernel-owner+w=401wt.eu-S1755751AbZHJRHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbZHJRHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 13:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755584AbZHJRHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 13:07:55 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:46269 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508AbZHJRHy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 13:07:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=B+zQQkcB6Xpqju8wdkzAQobaUj8ZZR8I4f7J56GV6hoA8gy8/t208WnzmUpYDs8EoQ
         IAPCJ82fdxkKtDqmt/ePLEAYBMjuX0IdIHxtEtEjxy2GJFN1T4QIU14dq/b+KDMG8Z9s
         /dBxODVQU+sOa6URA94rXJs3XR6VKdzegn8A0=
MIME-Version: 1.0
In-Reply-To: <4A803CE7.20201@gmail.com>
References: <4A803CE7.20201@gmail.com>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Mon, 10 Aug 2009 10:07:35 -0700
X-Google-Sender-Auth: a6a6074a98131070
Message-ID: <2c0942db0908101007t54c39b64k2800b2c320969318@mail.gmail.com>
Subject: Re: xterm loses data (pty regression)
To: Artur Skawina <art.08.09@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ adding CC:s ]

On Mon, Aug 10, 2009 at 8:29 AM, Artur Skawina <art.08.09@gmail.com> wrote:
>
> [I have now gone back to 2.6.30.3 and the writes to the ptys do block there,
>  so it's a recent regression.]
>
> First noticed it after upgrading to v2.6.31-rc5-246-g90bc1a6, still happens
> in rc5-381-g7b2aa03.
> If i press ^S in an xterm the output stops as expected, but after a ^Q i see
> only the newly written data, everything in between is lost. Like:
>
> > for i in `seq 1 111`; do echo $i; sleep 1; done
> 1
> 2
> 3
> 4
> 9
> 10
> 11
> 12
> 13
> ^C
>
> [typed ^S after '4', then ^Q after a few seconds]
>
> If the command doing the printing exits before the ^Q is sent, i don't get
> any reaction to the ^Q at all, which is why i initially thought it to be an
> xserver bug.
> Text consoles are unaffected, output resumes as it should.
>
> artur
