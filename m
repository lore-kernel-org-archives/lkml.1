Return-Path: <linux-kernel-owner+w=401wt.eu-S1758453AbYBXQcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758453AbYBXQcW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 11:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYBXQcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 11:32:03 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:31323 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbYBXQcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 11:32:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=tpmfSROSyL0aumrDgzxQ/WGzPlwVLSJTD1E8jzSLJVVTZcpt9rivPv0YFVhkGxXkMVbAb4MItYhJiqE45PxPqEggjjgzkowQfUZJyVCj15Na0A58V1OpwWj7GiUqE/fY0AzbFYfezGqK53AC+ULBjb20ZgOUFJy6warUL1fn8j0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [Fixed PATCH] hpt366: fix section mismatch warnings
Date: Sun, 24 Feb 2008 15:33:51 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
References: <20080222194651.GA7154@uranus.ravnborg.org> <20080223212222.GA16568@uranus.ravnborg.org>
In-Reply-To: <20080223212222.GA16568@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802241533.51671.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 February 2008, Sam Ravnborg wrote:
> hpt366: fix section mismatch warnings
> 
> Fix following warnings:
> WARNING: o-sparc64/vmlinux.o(.data+0x195a38): Section mismatch in reference from the variable hpt37x_info.0 to the variable .devinit.data:hpt370
> WARNING: o-sparc64/vmlinux.o(.data+0x195a40): Section mismatch in reference from the variable hpt37x_info.0 to the variable .devinit.data:hpt370a
> WARNING: o-sparc64/vmlinux.o(.data+0x195a48): Section mismatch in reference from the variable hpt37x_info.0 to the variable .devinit.data:hpt372
> WARNING: o-sparc64/vmlinux.o(.data+0x195a50): Section mismatch in reference from the variable hpt37x_info.0 to the variable .devinit.data:hpt372n
> 
> Replace a static array with a small switch resulting in
> more readable code.
> Mark the pci table __devinitconst.
> 
> A lot of variables are const but annotated __devinitdata.
> Annotating them __devinitconst would cause a section type
> conflict error when build for 64 bit powerpc.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> ---

thanks, applied

> The first patch I posted caused a section type conflict when
> build for 64 bit powerpc. The actual cause of this is know and unavoidable
> when we start to declare variables const.
> The patch attached is much simpler as the transition from __devinitdata
> to __devinitconst turned out to be bogus.

Weird, I thought that the main purpose of __devinitconst was to replace
const + __devinitdata?
