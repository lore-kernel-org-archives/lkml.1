Return-Path: <linux-kernel-owner+w=401wt.eu-S1753709AbZEYX55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbZEYX55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 19:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbZEYX5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 19:57:49 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:58957 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752778AbZEYX5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 19:57:48 -0400
From: Frans Pop <elendil@planet.nl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/3] ide: add "ignore_hpa" module parameter
Date: Tue, 26 May 2009 01:06:12 +0200
User-Agent: KMail/1.9.9
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200905252344.11826.bzolnier@gmail.com> <200905260027.39330.elendil@planet.nl> <20090525233643.0a47e950@lxorguk.ukuu.org.uk>
In-Reply-To: <20090525233643.0a47e950@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905260106.13705.elendil@planet.nl>
X-OriginalArrivalTime: 25 May 2009 23:06:13.0986 (UTC) FILETIME=[66B25420:01C9DD8D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 May 2009, Alan Cox wrote:
> > It's also not obvious (at least not to a dumb user like me) that
> > "ignore HPA limit" is equivalent to "preserving the Host Protected
> > Area" as the commit commit says.
>
> It isn't - its the exact reverse.

Right.

> Ignoring the HPA limit tells the kernel to ignore the system BIOS and
> firmware set defaults and to stomp the whole disk regardless. On a
> modern system thats almost always a really bad idea. Unfortunately on
> ancient boxes with disk jumpers set to lie about the disk size (32GB
> clipping etc) its the right thing.
>
> Having the same parameter in both stacks seems a good idea but really
> we need Tejun's patch exposing the values and then to propogate the hpa
> ignore into sysfs and trigger a revalidate of the disk if you change
> it. Libata has all the framework for that ready just needing the final
> bits. I don't see anything problematic in old IDE also having that
> interface.

That also sounds as if it would better protect (or at least inform) 
existing users who have file systems on disks where the HPA is currently 
being ignored.

Seems to me this whole issue would also be worth an LWN (BCCed) article to 
raise awareness, explain the issue, maybe give practical info how to test 
whether you're affected, and maybe add some advice to distributions how 
to handle it. Seems to me like it's something that should be mentioned in 
distribution release notes.

Cheers,
FJP
