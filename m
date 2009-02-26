Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbZBZDF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbZBZDF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 22:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbZBZDFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 22:05:47 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:49140 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbZBZDFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 22:05:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=D2GBYkeugzCq85iODsClpYHgZUzMs5+zX7Mf/Lx2rmUPHQkKUffWgJnr4sKBlq93cS
         mMjRTPOuqn9S8AIX/4WmiF2QqjotLWJ5e21UPhso3JWwRLybX/qls324cI+1AmSm44v5
         VS8Te5uI2Mq67MNtM+fuGGN8ELMBHVZ5I/uKc=
Subject: Re: [RFC] introduce pr_cont macro
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20090226030315.GB7526@elte.hu>
References: <20090225205920.GA22091@localhost>
	 <20090226030315.GB7526@elte.hu>
Content-Type: text/plain
Date: Wed, 25 Feb 2009 19:05:41 -0800
Message-Id: <1235617541.5610.0.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 04:03 +0100, Ingo Molnar wrote:
> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
> > We cover all log-levels by pr_... macros except
> > KERN_CONT one. Add it for convenience.
> > 
> > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> > ---
> > 
> > I think start printing with some pr_... macro
> > and continue with printk(KERN_CONT ...) look
> > not that clear -- better to continue with
> > same pr_... slogan. Thoughts? I hope I didn't
> > miss anything.
> > 
> >  include/linux/kernel.h |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > Index: linux-2.6.git/include/linux/kernel.h
> > ===================================================================
> > --- linux-2.6.git.orig/include/linux/kernel.h
> > +++ linux-2.6.git/include/linux/kernel.h
> > @@ -370,6 +370,8 @@ static inline char *pack_hex_byte(char *
> >          printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
> >  #define pr_info(fmt, ...) \
> >          printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
> > +#define pr_cont(fmt, ...) \
> > +        printk(KERN_CONT pr_fmt(fmt), ##__VA_ARGS__)
> 
> Makes sense.
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>
> 

Don't you want to omit the pr_fmt() from the KERN_CONT case?

Harvey

