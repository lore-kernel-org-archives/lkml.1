Return-Path: <linux-kernel-owner+w=401wt.eu-S1758751AbYAHO12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751AbYAHO12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 09:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752328AbYAHO1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 09:27:18 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48983 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbYAHO1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 09:27:17 -0500
Date: Tue, 8 Jan 2008 06:26:56 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: DM <dm.n9107@gmail.com>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu
Subject: Re: [patch 2/2] track and print last unloaded module in the oops
 trace
Message-ID: <20080108062656.311cd3aa@laptopd505.fenrus.org>
In-Reply-To: <5eeb9ad90801080551n562b9f15o27b495495a452c22@mail.gmail.com>
References: <20080106151946.50c3d8cc@laptopd505.fenrus.org>
	<5eeb9ad90801080551n562b9f15o27b495495a452c22@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008 14:51:37 +0100
DM <dm.n9107@gmail.com> wrote:

> On Jan 7, 2008 12:19 AM, Arjan van de Ven <arjan@infradead.org> wrote:
> [...]
> > This patch tracks the last unloaded module, and prints this as part
> > of the module list in the oops trace.
> >
> [...]
> >        }
> > +       /* Store the name of the last unloaded module for
> > diagnostic purposes */
> > +       sprintf(last_unloaded_module, mod->name);
> >        free_module(mod);
> >
> 
> Why use sprintf? If a module name contains the % character we could
> overflow the buffer. Or is module-unloading root-only and we don't
> care?

module loading isn't just root only; the name comes from an already loaded module.
If you can load kernel modules of your choice you own the entire kernel already anway
