Return-Path: <linux-kernel-owner+w=401wt.eu-S1756973AbZEVTBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973AbZEVTBO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 15:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757358AbZEVTA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 15:00:57 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:43670 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757151AbZEVTAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 15:00:55 -0400
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 May 2009 15:00:54 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=cxG8DCLrkADDsOvhZ8i+xN3S4u9PZQuQ5s/LsNMorzuXTjUitXoTafbbkj+ksjhEDZ
         Mpq7xPflTDVF+VbT1k8uH27ujHzBFITDANxYwtQc3uSUdJv6MsAuXR33kv/AOZ6g9h0u
         md46/8aAwRPlxHLCqgpmx81ZD6XudEwqA71qg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 3/4] ide: respect quirk_drives[] list on all controllers
Date: Fri, 22 May 2009 20:59:07 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc6-next-20090518-05332-g0707b5a; KDE/4.2.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200905201734.42093.bzolnier@gmail.com> <4A15A7DD.1040300@ru.mvista.com>
In-Reply-To: <4A15A7DD.1040300@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905222059.08161.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 May 2009 21:13:33 Sergei Shtylyov wrote:
> Bartlomiej Zolnierkiewicz wrote:
> 
> > * Add ide_check_nien_quirk_list() helper to the core code
> >   and then use it in ide_port_tune_devices().
> 
> > * Remove no longer needed ->quirkproc methods from hpt366.c
> >   and pdc202xx_{new,old}.c.
> 
>     Haha, I remembered about that idea of yours and was thinking of 
> undertaking its implementation just yesterday. You've beten me to it. :-)

Sigh, if I knew I would concentrate on other things...

I did it only because there is outstanding ide-pmac bugreport probably
related to one of these quirky drives...

> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> 
> > Index: b/drivers/ide/ide-iops.c
> > ===================================================================
> > --- a/drivers/ide/ide-iops.c
> > +++ b/drivers/ide/ide-iops.c
> > @@ -269,6 +269,31 @@ no_80w:
> >  	return 0;
> >  }
> >  
> > +static const char *nien_quirk_list[] = {
> > +	"QUANTUM FIREBALLlct08 08",
> > +	"QUANTUM FIREBALLP KA6.4",
> > +	"QUANTUM FIREBALLP KA9.1",
> > +	"QUANTUM FIREBALLP KX13.6",
> > +	"QUANTUM FIREBALLP KX20.5",
> > +	"QUANTUM FIREBALLP KX27.3",
> > +	"QUANTUM FIREBALLP LM20.4",
> > +	"QUANTUM FIREBALLP LM20.5",
> > +	NULL
> > +};
> > +
> > +void ide_check_nien_quirk_list(ide_drive_t *drive)
> 
>     Why not reuse ide_in_drive_list()?

Should have been in patch #5/4 but I ran out of time, I will do it later
unless you would like to handle it...
