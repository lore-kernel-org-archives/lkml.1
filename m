Return-Path: <linux-kernel-owner+w=401wt.eu-S1758343AbYA3D2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343AbYA3D2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 22:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758946AbYA3DYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 22:24:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:38772 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758932AbYA3DYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 22:24:51 -0500
To: Pavel Roskin <proski@gnu.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Jon Masters <jonathan@jonmasters.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>
Subject: Re: ndiswrapper and GPL-only symbols redux
From: Andi Kleen <andi@firstfloor.org>
References: <1201641765.18773.35.camel@dv> <20080129224529.4b8016c3@core>
	<1201651006.23553.8.camel@dv>
Date: Wed, 30 Jan 2008 04:24:50 +0100
In-Reply-To: <1201651006.23553.8.camel@dv> (Pavel Roskin's message of "Tue\, 29 Jan 2008 18\:56\:46 -0500")
Message-ID: <p73bq746lml.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Roskin <proski@gnu.org> writes:
>
> static inline void add_taint_module(struct module *mod, unsigned flag)
> {
>         add_taint(flag);
>         mod->taints |= flag;
> }
>
> The module taint is set before the symbols are resolved.  Therefore, the
> GPL-only symbols won't be resolved.

I think using a separate taint flag that does not disable GPL symbols
for the ndiswrapper case would be a fair solution. After all the main
motivation for tainting ndiswrapper is to make it visible in oopses, but not 
prevent it from loading in the first place.

How about you submit an incremental patch to do that?

-Andi
