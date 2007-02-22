Return-Path: <linux-kernel-owner+w=401wt.eu-S1751710AbXBVQ5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbXBVQ5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 11:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbXBVQ5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 11:57:00 -0500
Received: from mail.suse.de ([195.135.220.2]:59837 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbXBVQ47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 11:56:59 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [patch 03/18] Dont leak NT bit into next task
Date: Thu, 22 Feb 2007 17:56:56 +0100
User-Agent: KMail/1.9.5
Cc: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org
References: <20070221014413.282048309@mini.kroah.org> <erh57g$oeb$1@sea.gmane.org> <20070222152938.GP13958@stusta.de>
In-Reply-To: <20070222152938.GP13958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702221756.56185.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 February 2007 16:29, Adrian Bunk wrote:
> On Wed, Feb 21, 2007 at 11:00:15AM +0100, Giuseppe Bilotta wrote:
> > On Wednesday 21 February 2007 02:49, Greg KH wrote:
> > 
> > >  /* frame pointer must be last for get_wchan */
> > > -#define SAVE_CONTEXT    "pushq %%rbp ; movq %%rsi,%%rbp\n\t"
> > > -#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp\n\t"
> > > +#define SAVE_CONTEXT    "pushf ; pushq %%rbp ; movq %%rsi,%%rbp\n\t"
> > > +#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp ; popf\t"
> > 
> > No idea if this is a problem or not, but you forgot a \n after popf.
> 
> A discussion of this issue is in the thread starting with [1]
> (and I'd re-add the \n in -stable kernels with the patch below 
>  (stolen from 2.6.16) no matter what happened in Linus' tree).

The newline only helps some broken out of tree patches (which I won't name here)
that shouldn't touch this anyways.

-Andi

