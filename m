Return-Path: <linux-kernel-owner+w=401wt.eu-S1759865AbXGCL4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759865AbXGCL4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 07:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759189AbXGCLz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 07:55:56 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:52911 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759028AbXGCLzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 07:55:55 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 3 Jul 2007 13:55:49 +0200
User-Agent: KMail/1.9.7
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-pm@lists.linux-foundation.org,
       nigel@nigel.suspend2.net, mjg59@srcf.ucam.org,
       linux-kernel@vger.kernel.org
References: <20070703042916.GA17240@srcf.ucam.org> <200707031307.41366.oliver@neukum.org> <1183463053.10386.112.camel@localhost.localdomain>
In-Reply-To: <1183463053.10386.112.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707031355.51028.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 3. Juli 2007 schrieb Benjamin Herrenschmidt:
> > Now device drivers have a guaranteed temporal sequence:
> > 
> > last io -> suspend() -> resume() [or disconnect()] -> new io
> 
> No, that's always been bullshit. You can have IOs emitted by kernel
> threads (think knfsd, and that's just one among many others). Beside,

That's why we have the problem of freezing the kernel threads or not.
Short of knfsd very few kernel threads really operate on their own and
those can use the new notifier chain.

> relying on having userland frozen means that your driver will be unable
> to be "live" suspended/resumed for more ambitious dynamic power
> management schemes.

Only if they work without cooperation and idle detection in the drivers.

> So it's always been wrong, imho, to rely on that. I've had powermac STR
> work fine without the freezer for years, and few drivers have been a
> problem, and we just fixed them.

Powermacs are somewhat limited in hardware used with them (OK, powerbook
have PCMCIA, but how often is that used?)

You want to have all that pain for fuse?

	Regards
		Oliver
