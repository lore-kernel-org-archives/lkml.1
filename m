Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbYKND1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbYKND1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 22:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbYKND1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 22:27:14 -0500
Received: from mail-gx0-f11.google.com ([209.85.217.11]:39049 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbYKND1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 22:27:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wW5x0HlCsOxWlzB7DFjS+rjlxlvREhfF3JoflCZRPR1h/pbqm6RVDe4sIX/rNWDu94
         03pGt6vwrU2yvhqUMXOjV7ZBMQaxFMX/dcMmltL05dE2eFDKNKlQzce6iaf6Ge6fuUjG
         e0cuIYkZMyHQdVok9SovKqRX1y0yIUOs6JQ50=
Message-ID: <b9df5fa10811131927g56d9887jdda1d1ec0d7f8c07@mail.gmail.com>
Date: Fri, 14 Nov 2008 09:27:10 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/2] x86: Fixing improper annotation.
Cc: "Rufus & Azrael" <rufus-azrael@numericable.fr>,
       "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <b9df5fa10811111635i1154a9a3la5b9fbcfef4df9dc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49193D1A.9040000@numericable.fr> <20081111103649.GA10554@elte.hu>
	 <491962FE.1020805@numericable.fr> <20081111104112.GC10554@elte.hu>
	 <b9df5fa10811111635i1154a9a3la5b9fbcfef4df9dc@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/08, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> On 11/11/08, Ingo Molnar <mingo@elte.hu> wrote:
>
>  >
>  > okay - so i wont apply them until the full scope of the problems here
>  >  is mapped. We might be best off by marking xsave_cntxt_init() non-init
>  >  altogether for the time being?
>
> But, it's been called from an __init section, it will also trigger an
>  warning too. So, it
>   will remain as it was. If we goes to hunt these warnings ( I mean
>  we've to replace __init __alloc_bootmem() with __cpuinit
>  __alloc_bootmem() ) , it's not certain when it will stop. Likely , we
>  need to replace a lots of __init with __cpuinit.
>
Actually , if we replace __init __alloc_bootmem() with __cpuinit
__alloc_bootmem() that doesn't solve the problem. The mentioned
warning generates when CONFIG_ARCH_BOOTMEM_NODE=y is set. I think Ingo
is right. We can mark xsave_cntxt_init() as non-init. And we could
teach modpost to not to generate the warning
with __ref. Can we, Ingo ?
>  Rakib
>  >
>  >         Ingo
>  >
>
