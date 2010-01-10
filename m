Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361Ab0AJKil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab0AJKil (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 05:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096Ab0AJKik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 05:38:40 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:52763 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab0AJKij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 05:38:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vDuQChEgLw5zeNlDCSMIeCZF3UtkCD75PWCmxf4z3ULzlVbWALm32lk2KNkg/uRVck
         V39pWm1jExy8rGCyXRA78FkJJeJl0FZxSlZgtNibzWEFg8yONmeHNABmCXZ0MBcmsIDB
         sKvLNjQv2C/rc6fvHlTywW8yRPmDxnstzAjSg=
MIME-Version: 1.0
In-Reply-To: <20100110074529.GF7840@bicker>
References: <20100110074529.GF7840@bicker>
Date: Sun, 10 Jan 2010 10:38:37 +0000
Message-ID: <9b2b86521001100238x5c373f7x856a255e940baa5d@mail.gmail.com>
Subject: Re: [patch] hp-wmi: fix double free
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Dan Carpenter <error27@gmail.com>, linux-kernel@vger.kernel.org
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/10/10, Dan Carpenter <error27@gmail.com> wrote:
> kfree(obj) was called earlier.
>
> This was found by smatch and has only been compile tested.  :/

I don't see hp-wmi in MAINTAINERS, but in general platform drivers go
via the ACPI tree.

It looks like several others have discovered this issue the hard way
:-).  <http://www.pubbs.net/kernel/201001/14288/>.

Fortunately it has been fixed in the acpi tree and now submitted to
Linus.  <http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-01/msg02511.html>.

Regards
Alan

> --- orig/drivers/platform/x86/hp-wmi.c	2010-01-09 21:43:13.000000000 +0300
> +++ devel/drivers/platform/x86/hp-wmi.c	2010-01-09 21:43:28.000000000 +0300
> @@ -388,8 +388,6 @@ static void hp_wmi_notify(u32 value, voi
>  	} else
>  		printk(KERN_INFO "HP WMI: Unknown key pressed - %x\n",
>  			eventcode);
> -
> -	kfree(obj);
>  }
