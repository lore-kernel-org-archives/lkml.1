Return-Path: <linux-kernel-owner+w=401wt.eu-S1759314AbXJYVrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbXJYVrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 17:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758395AbXJYVqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 17:46:46 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:56100 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758313AbXJYVqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 17:46:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=IEGgyvT1n7+CGo3B6hTYRzItdeyCMLjW8kM8zz5F64ww2o9RAvzHV+XfzFW8UuRk4UXz5Ej59nF5F1vvruLqlVisn2cnjkVXO60kx4lJHzQ0WvmliV0dLXzfRsHBSvHpC0Z5uvWmPEdd6hSwHrxLhumzrLPfNr7xSfCW+m/qO1s=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [IDE] Fix build bug
Date: Thu, 25 Oct 2007 23:52:31 +0200
User-Agent: KMail/1.9.7
Cc: Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-mips@linux-mips.org
References: <20071025135334.GA23272@linux-mips.org> <20071025141305.GA11698@uranus.ravnborg.org>
In-Reply-To: <20071025141305.GA11698@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710252352.32141.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 October 2007, Sam Ravnborg wrote:
> On Thu, Oct 25, 2007 at 02:53:34PM +0100, Ralf Baechle wrote:
> >   CC      drivers/ide/pci/generic.o
> > drivers/ide/pci/generic.c:52: error: __setup_str_ide_generic_all_on causes a
> > +section type conflict
> > 
> > This sort of build error is becoming a regular issue.  Either all or non
> > of the elements that go into a particular section of a compilation unit
> > need to be const.  Or an error may result such as in this case if
> > CONFIG_HOTPLUG is unset.
> So we can avoid this if we invent a __constinitdata tag that uses
> a new section?

I asked similar question on LKML few days ago together with the list of
potentially problematic places:

	http://article.gmane.org/gmane.linux.kernel/594427

Now I see that the list is only partially complete since __initdata and co.
may be also hidden in things like __setup() etc.

Thanks,
Bart
