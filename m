Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbXIKVk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbXIKVk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590AbXIKVkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:40:16 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:27602 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbXIKVkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:40:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=I+D9V0SXGP6hACAULp04gua9TPpdma58FruWfeEIVj6K5rA9XK+3m1D3lZ4nzhfOyI83PRtymEjJqEdACfNmvmxlGk1umTQ8yyPDHYmA4ATeR12QL207c0QQhP3pv/wH1NUAm2OsbEkoofW5IwanUJEEd7oqq92QLUmi2II9nak=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 2/4] hpt366: MWDMA filter for SATA cards
Date: Tue, 11 Sep 2007 23:08:25 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200709030019.22732.sshtylyov@ru.mvista.com> <46DB1C50.2020205@ru.mvista.com> <46E28F01.7010808@ru.mvista.com>
In-Reply-To: <46E28F01.7010808@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200709112308.26095.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 September 2007, Sergei Shtylyov wrote:
> Hello, I wrote:
> Sergei Shtylyov wrote:
> 
> >    The patch was 4/4 of course. :-<
> >     Probably I was too esctatic about the code. ;-)
> 
>     Or rarher me. :-)
> 
> >> The Marvell bridge chips used on HighPoint SATA cards do not seem to 
> >> support
> >> the MWDMA modes (at least that caould be seen in their so-called 
> >> drivers :-),
> >> so the driver needs to account for this -- to achieve this:
> 
> >> - add mdma_filter() method from the original patch by Bartlomiej 
> >> Zolnierkewicz
> >>   with his consent, also adding the method callout to ide_rate_filter();
> 
> >> - installed the method for all chips to only return empty mask if a 
> >> SATA drive
> >>   is detected onHPT372{AN]/374 chips...
> 
> >> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

I pushed all your bugfix patches that were in IDE tree to Linus so
(after "the pull") please resync and resend the outstanding patches.

> >> ---
> >> This patch against the current Linus' tree and unfortunately I was 
> >> able to only
> >> compile test it since that tree gives MODPOST warning and dies early 
> >> on bootup.
> >> Will hopefully try to test if/when I have time... :-)
> 
>     And it was still the same -- I'd bisected if I had time...

:(

> >> Index: linux-2.6/drivers/ide/pci/hpt366.c
> >> ===================================================================
> >> --- linux-2.6.orig/drivers/ide/pci/hpt366.c
> >> +++ linux-2.6/drivers/ide/pci/hpt366.c
> >> @@ -1,5 +1,5 @@
> >>  /*
> >> - * linux/drivers/ide/pci/hpt366.c        Version 1.12    Aug 25, 2007
> >> + * linux/drivers/ide/pci/hpt366.c        Version 1.13    Aug 22, 2007
> 
> >    Errr... and version shuold Aug 02 -- thought I've fixed that. :-/
> 
>     Hehe, thanks.  Those versions turned to be quite PITA a to keep.

I think we should get rid of these "old-style" versions and convert
all IDE host drivers to use "new-style" versions (DRV_VERSION define
+ MODULE_VERSION(DRV_VERSION)).  Any volunteers? :)

Thanks,
Bart
