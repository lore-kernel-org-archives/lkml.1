Return-Path: <linux-kernel-owner+w=401wt.eu-S1764072AbYENTzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764072AbYENTzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 15:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763778AbYENTyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 15:54:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:42415 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763151AbYENTyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 15:54:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=yB3IhXRbx+54cgnXB0Th5BetftnWcjHkN0WKH/TU8DxBrOYBlmvdjT77VtryrGVOKynl/iK2CMbkOn5q5OhGHujmRxMPpTHk4lCAlB2KmWWKXPH0Fzkh9W+ix8iBuXeq1LfVSHmeZgfaKAPRAjnbo+6sm5HW2Pw0W1+gxZTNgVk=
Date: Thu, 15 May 2008 00:49:30 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OSS trident: switch from ->write_proc
Message-ID: <20080514204930.GA10513@martell.zuzino.mipt.ru>
References: <20080513210544.GB23977@martell.zuzino.mipt.ru> <20080514054707.GB6682@il.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514054707.GB6682@il.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 08:47:08AM +0300, Muli Ben-Yehuda wrote:
> Thanks Alexey, some comments below. This patch is a step in the right
> direction but I'm afraid it's currently broken.
> 
> On Wed, May 14, 2008 at 01:05:44AM +0400, Alexey Dobriyan wrote:
> 
> > @@ -4441,11 +4446,8 @@ trident_probe(struct pci_dev *pci_dev, const struct pci_device_id *pci_id)
> >  		/* ALi SPDIF OUT function */
> >  		if (card->revision == ALI_5451_V02) {
> >  			ali_setup_spdif_out(card, ALI_PCM_TO_SPDIF_OUT);
> > -			res = create_proc_entry("ALi5451", 0, NULL);
> > -			if (res) {
> > -				res->write_proc = ali_write_proc;
> > -				res->data = card;
> > -			}
> > +			proc_create_data("ALi5451", 0, NULL,
> > +					 &ali_proc_fops, card);
> >  		}
> >  
> >  		/* Add H/W Volume Control By Matt Wu Jul. 06, 2001 */
> 
> This is not enough--we need to also remove the proc_entry if
> trident_probe() fails (see label `out_proc_fs'), which will require
> checking if proc_create_data() succeeded. Please send an updated patch
> or let me know and I'll take care of it.

Sorry, I just want to remove ->write_proc totally and auditing proc
users are for later.

