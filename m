Return-Path: <linux-kernel-owner+w=401wt.eu-S1759833AbZFPSVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759833AbZFPSVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 14:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbZFPSU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 14:20:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751596AbZFPSU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 14:20:57 -0400
Date: Tue, 16 Jun 2009 11:20:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ryan Hope <rmh3093@gmail.com>
cc: Dave Airlie <airlied@gmail.com>, Greg KH <greg@kroah.com>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm - fixes + radeon KMS (part 2)
In-Reply-To: <48f7fe350906160853m41f43fe5i892a4057b5eae319@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0906161119500.3282@localhost.localdomain>
References: <alpine.DEB.2.00.0906150302250.20307@skynet.skynet.ie>  <20090615022235.GA12905@kroah.com>  <21d7e9970906141943s8dd6e27sd4308413601d65e3@mail.gmail.com> <48f7fe350906160853m41f43fe5i892a4057b5eae319@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Jun 2009, Ryan Hope wrote:
> 
> +#ifdef MODULE
>  module_init(radeon_init);
> +#else
> +late_initcall(radeon_init);
> +#endif


You should never need something like that.

Just do

	late_initcall(radeon_init);

and if it's a module (which doesn't have "early" vs "late" etc), it will 
just be a normal module_init.

		Linus
