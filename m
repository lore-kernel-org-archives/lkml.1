Return-Path: <linux-kernel-owner+w=401wt.eu-S2992984AbXEBJ6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992984AbXEBJ6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 05:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993002AbXEBJ6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 05:58:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36844 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992999AbXEBJ6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 05:58:30 -0400
From: Andi Kleen <ak@novell.com>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH] Remove unnecessary irq disabling
Date: Wed, 2 May 2007 11:58:17 +0200
User-Agent: KMail/1.9.6
Cc: Mark Lord <lkml@rtr.ca>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <20070501213050.GD6119@redhat.com> <4637D459.2040502@rtr.ca> <20070502044424.GA7049@redhat.com>
In-Reply-To: <20070502044424.GA7049@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705021158.17759.ak@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > What does that break, or was it already broken and this fixes it?
> I think neither. This function is only called at early bootup,
> (start_secondary() ), and most of its callees have interrupts off anyway.
> But maybe we do lose something. Andi, do you have a word on this?

We need to enable them somewhere, but cpu_idle will do it in the end.
So it should be safe to drop it. I guess keeping them disabled the whole
time will be a little safer against potential races.

I added the patch, but might want some cooking in -mm first because this
is always fragile code.

-Andi
