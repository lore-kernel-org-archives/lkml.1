Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbZFGOZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbZFGOZu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 10:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755279AbZFGOZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 10:25:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:63538 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522AbZFGOZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 10:25:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HyQBdbwAnPkKLvbReYNYazTRv31BzojDvIf/WaWnHRoMJCneTS/d4BEJ/tv05QGVUy
         q443oT83BitFX0Kjq1HMyK/ElRzl1OcmZjtGaCBI3aJXX9+ikYhOl+qBhBHXQMAhJe7S
         m4M/pxT9s8/XMiGdHm/rTGX0h8fVLBW6ae8nQ=
Subject: Re: [PATCH RESEND]X86:microcode: fix vfree()
From: "Figo.zhang" <figo1802@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20090607142118.GB21340@elte.hu>
References: <1244351929.3355.13.camel@myhost>
	 <20090607140113.GI12088@elte.hu> <1244384315.3402.5.camel@myhost>
	 <20090607142118.GB21340@elte.hu>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 22:25:15 +0800
Message-Id: <1244384715.3402.8.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-07 at 16:21 +0200, Ingo Molnar wrote:
> (Note: it's not a 'resend', it's v2 of the patch)
> 
> * Figo.zhang <figo1802@gmail.com> wrote:
> 
> > vfree() does its own 'NULL' check, so no need for check before
> > calling it.
> > 
> > Signed-off-by: Figo.zhang <figo1802@gmail.com>
> > ---   
> > arch/x86/kernel/microcode_amd.c |   13 +++++--------
> >  1 files changed, 5 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
> > index 453b579..8f52cf4 100644
> > --- a/arch/x86/kernel/microcode_amd.c
> > +++ b/arch/x86/kernel/microcode_amd.c
> > @@ -257,10 +257,9 @@ static int install_equiv_cpu_table(const u8 *buf)
> >  
> >  static void free_equiv_cpu_table(void)
> >  {
> > -	if (equiv_cpu_table) {
> > -		vfree(equiv_cpu_table);
> > -		equiv_cpu_table = NULL;
> > -	}
> > +	vfree(equiv_cpu_table);
> > +	equiv_cpu_table = NULL;
> > +

i motify by vim, you said this line?

Best Regards,

Figo.zhang

> 
> you fixed the tab but you didnt remove the stray newline :)
> 
> 	Ingo



