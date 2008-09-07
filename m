Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbYIGS1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbYIGS1l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 14:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbYIGS10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 14:27:26 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:42294 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbYIGS1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 14:27:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=ImlVu8AvMlHri530Bu9PmioYuHOzE3LuDrTW8QKM4QqbeoiE/NTAPYvNUVG9yDKLyZ
         vxxHH+vKEV3yaqJobPkAnZAtTdAZAKsU2nVVbp+Y5LHm77V1YGVLWcldOPsZxecNSq1a
         9BV7JWco9Gqtru/BzeVMgL/E7Eg9UpcYxnqXo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] Fix pointer arithmetic in hpt3xx driver code (3rd try)
Date: Sun, 7 Sep 2008 20:10:03 +0200
User-Agent: KMail/1.9.9
Cc: Masoud Sharbiani <masouds@google.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20080906171850.GF26371@google.com> <48C39D2F.4010701@ru.mvista.com> <48C3B909.3030405@ru.mvista.com>
In-Reply-To: <48C3B909.3030405@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809072010.04122.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Masoud/Sergei: sorry for the bug and thanks for fixing it.

On Sunday 07 September 2008, Sergei Shtylyov wrote:
> Hello, I wrote:
> >> diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
> >> index eb107ee..4eae284 100644
> >> --- a/drivers/ide/pci/hpt366.c
> >> +++ b/drivers/ide/pci/hpt366.c
> >> @@ -613,6 +613,14 @@ static int check_in_drive_list(ide_drive_t 
> >> *drive, const char **list)
> >>      return 0;
> >>  }
> >>  
> >> +static struct hpt_info *hpt3xx_get_info(struct device *dev)
> >> +{
> >> +    struct ide_host *host    = pci_get_drvdata(to_pci_dev(pci_dev));
> >>   
> >
> >   Oops, this just won't compile. :-/
> 
>    BTW, there's no need to invoke to_pci_dev() at all since 
> pci_get_drvdata(dev) boils down to dev_get_drvdata(&dev->dev) call. So, 
> in order not to waste time on useless pointer tricks, we should just 
> invoke the latter here.

I corrected this and applied the patch.
