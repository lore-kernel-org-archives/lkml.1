Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab0BRKIF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 05:08:05 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:58635 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308Ab0BRKIB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 05:08:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=iTmdrmZUGzezi6HNuY8zi2mZzli4lLX2JihODWvjhF39+lTTlzCiPud//hG8akN/Y7
         IJFNYL042pATZmY32+ijbsJfgUMDOWViHEcOYt6YIzQBTMNehW41GJCOsKC1fkTD9/Ip
         +WP7g8EzAUFTF38rk2k2WM0D6wdhyYP9/AoMg=
MIME-Version: 1.0
In-Reply-To: <4B7D0ED3.5020409@redhat.com>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
	 <1266406962-17463-10-git-send-email-luca@luca-barbieri.com>
	 <4B7C7023.7060602@zytor.com>
	 <ff13bc9a1002171641w372a587j39632cb856b995f1@mail.gmail.com>
	 <4B7C8E04.6070605@zytor.com> <4B7D0ED3.5020409@redhat.com>
Date: Thu, 18 Feb 2010 11:07:58 +0100
X-Google-Sender-Auth: d443b83b821c7bc3
Message-ID: <ff13bc9a1002180207t1a75c974v4b9f48324b6cf6f6@mail.gmail.com>
Subject: Re: [PATCH 09/10] x86-32: use SSE for atomic64_read/set if available
From: Luca Barbieri <luca@luca-barbieri.com>
To: Avi Kivity <avi@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@elte.hu, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> One heavy user is set_64() in the pagetable code.  That's already in an
> expensive operation due to the page fault so the impact will be quite low,
> probably.
It currently does not use the atomic64_t infrastructure and thus won't
be affected currently, but can very easily be converted to cast the
pointer to atomic64_t* and use atomic64_set.

I think we set ptes in other places than the page fault handler.
Is any of them performance critical?
