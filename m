Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbYKEJ1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbYKEJ1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 04:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbYKEJ1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 04:27:23 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:3615 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbYKEJ1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 04:27:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=lDHIlhULBGh7yQZ5AfOB5glYPzaWudZUJD2ZwVEgr20AcBfdTs+60eYHeyxuFaY1rO
         bq8lNLPg+rB/PNYSLGQvKNmTW0C3oYwfV4XiAPTmaMhDSqzWv0Ymb95LvXqdY148DoQL
         s20YiwOMXV1JOvAgzh6TCEVoLqv3q/606tp9Q=
Message-ID: <491166F5.7030102@gmail.com>
Date: Wed, 05 Nov 2008 11:27:17 +0200
From: Lior Dotan <liodot@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>, gregkh@suse.de
CC: linux-kernel@vger.kernel.org, charrer@alacritech.com
Subject: Re: [STAGING] slicoss - use kzalloc
References: <491077E3.4010702@gmail.com> <4910C63F.7040309@gmail.com>
In-Reply-To: <4910C63F.7040309@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------080801050603000702090503"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080801050603000702090503
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

-------- Original Message --------
Subject: Re: [STAGING] slicoss - use kzalloc
From: Jiri Slaby <jirislaby@gmail.com>
To: Lior Dotan <liodot@gmail.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org, charrer@alacritech.com
Date: 11/05/2008 12:01 AM

> On 11/04/2008 05:27 PM, Lior Dotan wrote:
>> This patch uses kzalloc() where applicable.
>>
>> Signed-off-by: Lior Dotan <liodot@gmail.com>
> 
> /drivers/staging/slicoss/slicoss.c
> =======================================
> --- b/drivers/staging/slicoss/slicoss.c	2008-11-04 11:53:12.878116772 +0200
> +++ a/drivers/staging/slicoss/slicoss.c	2008-11-04 12:08:40.800644774 +0200
> @@ -2673,8 +2673,8 @@
> static·int·slic_card_init(struct·sliccar
> #if·SLIC_DUMP_ENABLED
> » if·(!card->dumpbuffer)·{
> -» » card->dumpbuffer·=·kmalloc(DUMP_PAGE_SIZE,·GFP_ATOMIC);
> +» » card->dumpbuffer·=·kzalloc(DUMP_PAGE_SIZE,·GFP_ATOMIC);
> » » ASSERT(card->dumpbuffer);
> » » if·(card->dumpbuffer·==·NULL)
> @@ -2683,8 +2683,7 @@
> static·int·slic_card_init(struct·sliccar
> » ·*··Smear·the·shared·memory·structure·and·then·obtain
> » ·*··the·PHYSICAL·address·of·this·structure
> » ·*/
> -» memset(card->dumpbuffer,·0,·DUMP_PAGE_SIZE);
> 
> 
> It's wrong, the function in called multiple times, the memset was called every
> time, now it would be called only for the first time.


You are right, thanks. Here's a fixed version.


This patch uses kzalloc() where really applicable.

Signed-off-by: Lior Dotan <liodot@gmail.com>

--------------080801050603000702090503
Content-Type: text/plain;
 name="slicoss-kzalloc.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="slicoss-kzalloc.patch"

LS0tIGIvZHJpdmVycy9zdGFnaW5nL3NsaWNvc3Mvc2xpY29zcy5jCTIwMDgtMTEtMDUgMTE6
MjE6MTMuNjk3Nzg5ODczICswMjAwCisrKyBhL2RyaXZlcnMvc3RhZ2luZy9zbGljb3NzL3Ns
aWNvc3MuYwkyMDA4LTExLTA1IDExOjI0OjAwLjc2ODM5OTE5NiArMDIwMApAQCAtMjgzMyw5
ICsyODMzLDggQEAgc3RhdGljIHUzMiBzbGljX2NhcmRfbG9jYXRlKHN0cnVjdCBhZGFwdAog
CX0KIAlpZiAoIXBoeXNjYXJkKSB7CiAJCS8qIG5vIHN0cnVjdHVyZSBhbGxvY2F0ZWQgZm9y
IHRoaXMgcGh5c2ljYWwgY2FyZCB5ZXQgKi8KLQkJcGh5c2NhcmQgPSBrbWFsbG9jKHNpemVv
ZihzdHJ1Y3QgcGh5c2NhcmQgKiksIEdGUF9BVE9NSUMpOworCQlwaHlzY2FyZCA9IGt6YWxs
b2Moc2l6ZW9mKHN0cnVjdCBwaHlzY2FyZCAqKSwgR0ZQX0FUT01JQyk7CiAJCUFTU0VSVChw
aHlzY2FyZCk7Ci0JCW1lbXNldChwaHlzY2FyZCwgMCwgc2l6ZW9mKHN0cnVjdCBwaHlzY2Fy
ZCAqKSk7CiAKIAkJREJHX01TRwogCQkgICAgKCJcbiVzIEFsbG9jYXRlIGEgUEhZU0lDQUxj
YXJkOlxuICAgIFBIWVNJQ0FMX0NhcmRbJXBdXG5cCg==
--------------080801050603000702090503--
