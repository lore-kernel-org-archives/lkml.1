Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbYIHRWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbYIHRWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 13:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbYIHRWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 13:22:11 -0400
Received: from smtp-out.google.com ([216.239.33.17]:23827 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbYIHRWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 13:22:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:to:cc:subject:message-id:references:mime-version:
	content-type:content-disposition:in-reply-to:user-agent:from;
	b=JUQcS7gl7NGfRV0pByude9r8Jr3IPur/TyZuq1PQh41zW0NfawNWmLX3W+7dXh/K2
	eP6fzJnQ6cHhp7igxKM8w==
Date: Mon, 8 Sep 2008 10:21:11 -0700
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] Fix pointer arithmetic in hpt3xx driver code (3rd try)
Message-ID: <20080908172111.GG26371@google.com>
References: <20080906171850.GF26371@google.com> <48C39D2F.4010701@ru.mvista.com> <48C3B909.3030405@ru.mvista.com> <200809072010.04122.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809072010.04122.bzolnier@gmail.com>
User-Agent: Mutt/1.5.11
From: masouds@google.com (Masoud Sharbiani)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 07, 2008 at 08:10:03PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> Masoud/Sergei: sorry for the bug and thanks for fixing it.
> 
> On Sunday 07 September 2008, Sergei Shtylyov wrote:
> > Hello, I wrote:
> > >> diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
> > >> index eb107ee..4eae284 100644
> > >> --- a/drivers/ide/pci/hpt366.c
> > >> +++ b/drivers/ide/pci/hpt366.c
> > >> @@ -613,6 +613,14 @@ static int check_in_drive_list(ide_drive_t 
> > >> *drive, const char **list)
> > >>      return 0;
> > >>  }
> > >>  
> > >> +static struct hpt_info *hpt3xx_get_info(struct device *dev)
> > >> +{
> > >> +    struct ide_host *host    = pci_get_drvdata(to_pci_dev(pci_dev));
> > >>   
> > >
> > >   Oops, this just won't compile. :-/
> > 
> >    BTW, there's no need to invoke to_pci_dev() at all since 
> > pci_get_drvdata(dev) boils down to dev_get_drvdata(&dev->dev) call. So, 
> > in order not to waste time on useless pointer tricks, we should just 
> > invoke the latter here.
> 
> I corrected this and applied the patch.

Thanks!

Masoud
