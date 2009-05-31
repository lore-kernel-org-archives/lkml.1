Return-Path: <linux-kernel-owner+w=401wt.eu-S1758265AbZEaKTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265AbZEaKTR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 06:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755447AbZEaKTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 06:19:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41372 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754508AbZEaKTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 06:19:06 -0400
Date: Sun, 31 May 2009 11:18:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: paul@mad-scientist.net
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] coredump: Retry writes where appropriate
Message-ID: <20090531111851.07eb1df3@lxorguk.ukuu.org.uk>
In-Reply-To: <1243748019.7369.319.camel@homebase.localnet>
References: <1243748019.7369.319.camel@homebase.localnet>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 May 2009 01:33:39 -0400
Paul Smith <paul@mad-scientist.net> wrote:

> coredump: Retry writes where appropriate
> 
> Core dump write operations (especially to a pipe) can be incomplete due
> to signal reception or possibly recoverable partial writes.

NAK this

> Previously any incomplete write in the ELF core dumper caused the core
> dump to stop, giving short cores in these cases.  Modify the core dumper
> to retry the write where appropriate.

The existing behaviour is an absolute godsend when you've something like
a core dump stuck on an NFS mount or something trying to core dump to
very slow media.

In fact the signals checks were *purposefully added* some time ago.

Alan
