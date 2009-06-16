Return-Path: <linux-kernel-owner+w=401wt.eu-S1763426AbZFPVFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763426AbZFPVFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 17:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756614AbZFPVFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 17:05:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37748 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814AbZFPVFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 17:05:40 -0400
Date: Tue, 16 Jun 2009 23:00:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Eugene Teo <eugene@redhat.com>,
       James Morris <jmorris@namei.org>, Roland McGrath <roland@redhat.com>,
       solar@openwall.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] shift current_cred() from __f_setown() to f_modown()
Message-ID: <20090616210015.GA1879@redhat.com>
References: <4A36532E.3050006@redhat.com> <20090615174544.GA10467@redhat.com> <4A36E555.80206@redhat.com> <20090616183829.GA10027@redhat.com> <alpine.LFD.2.01.0906161224110.3282@localhost.localdomain> <20090616200746.GA28663@redhat.com> <alpine.LFD.2.01.0906161319480.3282@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906161319480.3282@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16, Linus Torvalds wrote:
>
>
> On Tue, 16 Jun 2009, Oleg Nesterov wrote:
> >
> > Shift current_cred() from __f_setown() to f_modown(). This reduces
> > the number of arguments and saves 48 bytes from fs/fcntl.o.
>
> Ok, I know I asked for this, but now I suddenly start worrying about
> whether f_owner.uid/euid are initialized at all for the pid==NULL case?
>
> They used to be initialized to zero, now they are left alone. Are they
> initialized somewhere else earlier?

I think this is fine, but I should have mentioned this in the changelog.

If f_owner.pid == NULL we never use f_owner.uid/euid. Otherwise we have
a bug anyway: we must not send signals if pid was reset to NULL.

Oleg.

