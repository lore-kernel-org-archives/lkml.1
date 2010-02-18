Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab0BRArG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 19:47:06 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:45514 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276Ab0BRArC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 19:47:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rqirJ+eROgf8NRuqrmXCrxyeM4iUK3e+qE897i6HY4fQOLuUtSbvOCmhqehGJeR7V+
         9pIhcTglU8YWAqNQIkAsDzAYumvCWL0Ri4HHyK32ap+OGVvQYflePGoTbBfCsaP1QCLl
         hnemasMQk9n3ivVzNNDm0e8HtACswX8gaVLLU=
MIME-Version: 1.0
In-Reply-To: <4B7C6FC8.7090107@zytor.com>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
	 <1266406962-17463-11-git-send-email-luca@luca-barbieri.com>
	 <4B7C6FC8.7090107@zytor.com>
Date: Thu, 18 Feb 2010 01:46:59 +0100
X-Google-Sender-Auth: f28f144991f244f0
Message-ID: <ff13bc9a1002171646q1f504304yfd52b34803605d7d@mail.gmail.com>
Subject: Re: [PATCH 10/10] x86-32: panic on !CX8 && XMM
From: Luca Barbieri <luca@luca-barbieri.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> NAK in the extreme.
>
> This is not how we deal with these kinds of stuff.  If this really
> matters, we explicitly clear the CPU feature in the feature detect code.

The rationale is that a panic will likely be reported as a a bug and
this lets us know that such CPUs exist, which we may otherwise not
hear about.
The user may bypass the panic by altering the command line.

To avoid doing the panic, we could define an artificial "CX8_XMM"
flag, set it if CX8 && XMM and use that in the alternatives code in
the previous patch; this is a bit more intrusive.

We already manually set the CX8 flag on VIA CPUs that mistakenly not
report it, so that shouldn't be a problem.
