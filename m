Return-Path: <linux-kernel-owner+w=401wt.eu-S1758800AbYAHVXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbYAHVXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 16:23:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759224AbYAHVUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 16:20:52 -0500
Received: from ozlabs.org ([203.10.76.45]:48007 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759215AbYAHVUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 16:20:51 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 2/2] track and print last unloaded module in the oops trace
Date: Wed, 9 Jan 2008 08:20:27 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: DM <dm.n9107@gmail.com>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, ak@suse.de
References: <20080106151946.50c3d8cc@laptopd505.fenrus.org> <5eeb9ad90801080639h2992e9b7maec0339e4f763f65@mail.gmail.com> <20080108161846.GD32273@elte.hu>
In-Reply-To: <20080108161846.GD32273@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801090820.28440.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2008 03:18:46 Ingo Molnar wrote:
> * DM <dm.n9107@gmail.com> wrote:
> > On Jan 8, 2008 3:26 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> > > > Why use sprintf? If a module name contains the % character we could
> > > > overflow the buffer. Or is module-unloading root-only and we don't
> > > > care?
> > >
> > > module loading isn't just root only; the name comes from an already
> > > loaded module. If you can load kernel modules of your choice you own
> > > the entire kernel already anway
> >
> > Still, strcpy seems like a better choice IMHO.
>
> agreed, this just isnt obvious IMO:
>
> +       sprintf(last_unloaded_module, mod->name);
>
> 	Ingo

Yes, I've changed it to:
+	strlcpy(last_unloaded_module, mod->name, sizeof(last_unloaded_module));

In my tree.

Thanks,
Rusty.
