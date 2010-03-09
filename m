Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab0CITkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 14:40:07 -0500
Received: from lo.gmane.org ([80.91.229.12]:58960 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722Ab0CITkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 14:40:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Christophe Jaillet" <christophe.jaillet@wanadoo.fr>
Subject: Re: [patch] arch/powerpc/platforms/pseries/ras.c - cleanup
Date: Tue, 9 Mar 2010 07:14:50 +0100
Message-ID: <hn4p0r$gv7$1@dough.gmane.org>
References: <hn3osd$4in$1@dough.gmane.org> <Pine.LNX.4.64.1003082235030.5727@ask.diku.dk>
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: aorleans-157-1-66-63.w90-20.abo.wanadoo.fr
X-MSMail-Priority: Normal
X-Newsreader: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Antivirus: avast! (VPS 100308-1, 08/03/2010), Outbound message
X-Antivirus-Status: Clean
Cc: kernel-janitors@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I personaly think that yes, because the smaller, the better.

Could you write one of your semantic match and send the patches ?

CJ

"Julia Lawall" <julia@diku.dk> a écrit dans le message de
news:Pine.LNX.4.64.1003082235030.5727@ask.diku.dk...
> On Mon, 8 Mar 2010, Christophe Jaillet wrote:
>
> > From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
> >
> > Hi, here is a patch against arch/powerpc/platforms/pseries/ras.c.
> >
> > No need to memset (.., 0, ...) a buffer that is complety filled by a
memcpy
> > the line after.
>
> I find 14 occurrences of this in linux-next.  Could it be useful for
> something?
>
> julia
>
>
> >
> >
> > Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
> >
> > ---
> >
> > diff --git a/arch/powerpc/platforms/pseries/ras.c
> > b/arch/powerpc/platforms/pseries/ras.c
> > index 2b548af..7a401ed 100644
> > --- a/arch/powerpc/platforms/pseries/ras.c
> > +++ b/arch/powerpc/platforms/pseries/ras.c
> > @@ -276,7 +276,6 @@ static struct rtas_error_log
*fwnmi_get_errinfo(struct
> > pt_regs *regs)
> >       (errdata >= rtas.base && errdata < rtas.base + rtas.size - 16)) {
> >    savep = __va(errdata);
> >    regs->gpr[3] = savep[0]; /* restore original r3 */
> > -  memset(mce_data_buf, 0, RTAS_ERROR_LOG_MAX);
> >    memcpy(mce_data_buf, (char *)(savep + 1), RTAS_ERROR_LOG_MAX);
> >    errhdr = (struct rtas_error_log *)mce_data_buf;
> >   } else {
> >
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
kernel-janitors" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >



