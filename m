Return-Path: <linux-kernel-owner+w=401wt.eu-S934121AbYBOPA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934121AbYBOPA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 10:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759517AbYBOPAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 10:00:11 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:2676 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343AbYBOPAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 10:00:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qW404PEEC5C8p0tWmYMJaD9an/EXLlQ0tTKpRvdt2n4um/Da6vqegJo4oORWkKIjheYsqEPZ27xmBPVnJclIrJ/5cr1O7u005K3f8HptsJWAHOFVEKCzDd4m0eTq8MXQrlHY95hAV4JOl0LgXM66IB+EEZUJIZRBTy19cgv3MeM=
Subject: Re: Spurious completions during NCQ
From: Calvin Walton <calvin.walton@gmail.com>
To: Hugo Mills <hugo-lkml@carfax.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20080215134658.GB27745@vlad.carfax.org.uk>
References: <20080215134658.GB27745@vlad.carfax.org.uk>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 10:00:00 -0500
Message-Id: <1203087600.25150.5.camel@zem>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-15 at 13:46 +0000, Hugo Mills wrote:
> I'm getting these on my Dell Latitude D830:
> 
> Feb 15 13:06:00 willow kernel: ata1.00: exception Emask 0x2 SAct 0x4 SErr 0x0 action 0x2 frozen
> Feb 15 13:06:00 willow kernel: ata1.00: spurious completions during NCQ issue=0x0 SAct=0x4 FIS=004040a1:00000002

>    In some cases, there are several cmd/res lines listed. It's
> happening about once an hour or so (not correlated with any other
> event that I can see). It doesn't seem to be affecting operation of
> the machine, but it's making me nervous.
> 
>    Can anyone set my mind at rest? (Or suggest a fix?)

You didn't mention which SATA chipset your laptop has, but some quick
googling says that it's AHCI. Until 2.6.24, the AHCI driver has a
problem where it'll report superious NCQ completions due to a bug in the
driver logic.

> uname -a reports:
> Linux willow 2.6.23.1-hrt3 #1 SMP Sun Nov 4 14:51:20 GMT 2007 x86_64 GNU/Linux

The fix is simple, upgrade your kernel to 2.6.24 :)

>    It's a kernel.org kernel with the patch for tickless operation on
> amd64.

Handily, the 2.6.24 kernel.org kernel includes amd64 tickless support
already.

-- 
Calvin Walton <calvin.walton@gmail.com>


