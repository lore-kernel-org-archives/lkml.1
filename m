Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbZEaRri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbZEaRri (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 13:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbZEaRr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 13:47:29 -0400
Received: from smtp02.lnh.mail.rcn.net ([207.172.157.102]:52265 "EHLO
	smtp02.lnh.mail.rcn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbZEaRr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 13:47:29 -0400
Subject: Re: [PATCH] coredump: Retry writes where appropriate
From: Paul Smith <paul@mad-scientist.net>
Reply-To: paul@mad-scientist.net
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Olivier Galibert <galibert@pobox.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>
In-Reply-To: <20090531173144.0a552386@lxorguk.ukuu.org.uk>
References: <1243748019.7369.319.camel@homebase.localnet>
	 <20090531111851.07eb1df3@lxorguk.ukuu.org.uk>
	 <20090531140354.GA92675@dspnet.fr.eu.org>
	 <20090531173144.0a552386@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: GNU's Not Unix!
Date: Sun, 31 May 2009 13:46:19 -0400
Message-Id: <1243791979.7369.385.camel@homebase.localnet>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-31 at 17:31 +0100, Alan Cox wrote:
> The only source of signals during a dump should be external ones. Far
> better would be to set some kind of defined signal mask during the dump
> (say SIGPIPE, SIGINT, SIGQUIT) ? I agree with Paul's patch in the sense
> we don't want spurious SIGIO events or similar spoiling a dump.

Something similar to this is what Andi Kleen first proposed.  The issue
is that it modifies the signal mask for the process before the core was
dumped, so that the mask saved in the core was not the real mask used by
the process when it took the exception.

Andi mentioned this problem and suggested we'd need to keep the original
mask around to be saved in the core.  That would involve deeper hacking
in the ELF format but maybe this is the right answer.

