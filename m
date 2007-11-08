Return-Path: <linux-kernel-owner+w=401wt.eu-S1756525AbXKHFQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbXKHFQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 00:16:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750720AbXKHFPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 00:15:54 -0500
Received: from smtp115.plus.mail.re1.yahoo.com ([69.147.102.78]:26535 "HELO
	smtp115.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750708AbXKHFPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 00:15:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=G5Dptw6Rf+23Ppri+BVlK0Pb+wds77uL2NiJEdFUtfoMKsNn+dmhv1NO+2CNur1x0OId2/ykTHsTdb7ezOKiOXU+wC3xMQtECSybMqYnhTghd9PnnbsiF2+X80oO3MjHxH7pyLoHMvDUS58HtIxvfV07UTzqi2G/DoVajRNdBCM=  ;
X-YMail-OSG: H4UBUHAVM1mcAk9gfVmCLdBTVERJZ4S9GPHog7P3RTUzhKxDIUaS6GAaMdWiUBW7c4XVQpfjD84y_fd4XfIo18bAJ8Jk8X3MKJFHnt_za8KgzyrEjA--
Date: Thu, 8 Nov 2007 06:15:16 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [PATCH] mm/memory.c: remove warning from an uninitialized
	spinlock. was: Re: 2.6.21-rc7-mm2
Message-ID: <20071108051516.GA7061@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <20070426182519.GA4532@gollum.tnic> <20070427172230.94b82829.akpm@linux-foundation.org> <4633DD55.1020006@shadowen.org> <20070429065049.GB4446@gollum.tnic> <20070429022440.cb8fc8c4.akpm@linux-foundation.org> <20071107192003.GA22286@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071107192003.GA22286@goodmis.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 02:20:03PM -0500, Steven Rostedt wrote:
> > 
> > Introduce a macro for suppressing gcc from generating a warning about a
> > probable uninitialized state of a variable.
> > 
> > Example:
> > 
> > -	spinlock_t *ptl;
> > +	spinlock_t *uninitialized_var(ptl);
> > 
> > Not a happy solution, but those warnings are obnoxious.
> > 
> > - Using the usual pointlessly-set-it-to-zero approach wastes several
> >   bytes of text.
> > 
> > - Using a macro means we can (hopefully) do something else if gcc changes
> >   cause the `x = x' hack to stop working
> > 
> > - Using a macro means that people who are worried about hiding true bugs
> >   can easily turn it off.
> > 
> > Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> I just stumbled across this being in the kernel. Well, I'm finally glad
> it made it in, even though it was suggested one year earlier ;-)
> 
>   http://lkml.org/lkml/2006/5/11/50

yeah, this was Andrew's idea. The version in the kernel, in
contrast to yours, doesn't have a config option so you still
have to make really sure you're not aiding any bugs with it.

-- 
Regards/Gruﬂ,
    Boris.
