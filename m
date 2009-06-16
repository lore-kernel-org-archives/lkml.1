Return-Path: <linux-kernel-owner+w=401wt.eu-S1760389AbZFPUWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760389AbZFPUWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755481AbZFPUWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:22:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753438AbZFPUWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:22:37 -0400
Date: Tue, 16 Jun 2009 13:21:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Oleg Nesterov <oleg@redhat.com>
cc: David Howells <dhowells@redhat.com>, Eugene Teo <eugene@redhat.com>,
       James Morris <jmorris@namei.org>, Roland McGrath <roland@redhat.com>,
       solar@openwall.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] shift current_cred() from __f_setown() to f_modown()
In-Reply-To: <20090616200746.GA28663@redhat.com>
Message-ID: <alpine.LFD.2.01.0906161319480.3282@localhost.localdomain>
References: <4A36532E.3050006@redhat.com> <20090615174544.GA10467@redhat.com> <4A36E555.80206@redhat.com> <20090616183829.GA10027@redhat.com> <alpine.LFD.2.01.0906161224110.3282@localhost.localdomain> <20090616200746.GA28663@redhat.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Jun 2009, Oleg Nesterov wrote:
>
> Shift current_cred() from __f_setown() to f_modown(). This reduces
> the number of arguments and saves 48 bytes from fs/fcntl.o.

Ok, I know I asked for this, but now I suddenly start worrying about 
whether f_owner.uid/euid are initialized at all for the pid==NULL case?

They used to be initialized to zero, now they are left alone. Are they 
initialized somewhere else earlier?

		Linus
