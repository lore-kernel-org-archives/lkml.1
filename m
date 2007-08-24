Return-Path: <linux-kernel-owner+w=401wt.eu-S933547AbXHXTJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547AbXHXTJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 15:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762030AbXHXTJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 15:09:39 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:42592 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225AbXHXTJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 15:09:38 -0400
To: Arjan van de Ven <arjan@infradead.org>
Cc: Avi Kivity <avi@qumranet.com>, Laurent Vivier <Laurent.Vivier@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
From: laurent.vivier@bull.net
Subject: =?iso-8859-1?Q?R=E9f=2E_=3A_Re=3A_[PATCH]_export_i386_smp=5Fcall?=
 =?us-ascii?Q?=5Ffunction?= =?us-ascii?Q?=5Fmask?= =?us-ascii?Q?=28=29_?=
 =?us-ascii?Q?to?= modules
Date: Fri, 24 Aug 2007 21:14:57 +0200
Message-ID: <OFA7B0E6E4.F9F637CF-ONC1257341.0069BD11-C1257341.0069BD5D@frec.bull.fr>
X-MIMETrack: Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 24/08/2007 21:14:59
MIME-Version: 1.0
Content-type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On Fri, 24 Aug 2007 17:36:35 +0200
> Laurent Vivier <Laurent.Vivier@bull.net> wrote:
>
> > This patch export i386 smp_call_function_mask() with EXPORT_SYMBOL().
> >
> > This function is needed by KVM to call a function on a set of CPUs.
> >
> >  arch/i386/kernel/smp.c |    7 +++++++
> >  include/asm-i386/smp.h |    9 +++------
> >  2 files changed, 10 insertions(+), 6 deletions(-)
> >
> > Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
>
> hmm isn't it being an inline also making it available for KVM to use?
> If so... isn't your patch description entirely not matching what the
> code does?

It is available for KVM compilation, not for KVM use.

In fact smp_ops is not available for KVM use, so as
smp_call_function_mask() is smp_ops.smp_call_function_mask() we can say it
is not available...

My first reflex was to export smp_ops, but as it seems it is an internal
and hidden variable, it appears I should export smp_call_function_mask()
instead.

Laurent


