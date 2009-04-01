Return-Path: <linux-kernel-owner+w=401wt.eu-S1753639AbZDAGHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbZDAGHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 02:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756840AbZDAGG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 02:06:57 -0400
Received: from n18.bullet.mail.mud.yahoo.com ([68.142.206.145]:44636 "HELO
	n18.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754128AbZDAGGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 02:06:54 -0400
X-Yahoo-Newman-Id: 770679.70483.bm@omp416.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0kGV40Hl6KpE2yHrSnyHzBOIdMmPw5qku4HUTXMhCcrE96FK2QjYLhdX5dvKrc+olufn0BEZTiCD/LmR2T0+8u7B/qsTFNC43HjFRxB8L0GICg6noSZE8QeaxNUVxWHQ9X4AVJjoBVCxTFNNMVV0iFuin7QP+Ly+wE3v9poJl70=  ;
X-YMail-OSG: dtBbISUVM1mheQjNS2FQtqCxpzuo_7j_tPxh7d1GQJK9N2K9vYq_Qz_m.LQVAZyYXWcYwVCwNR.hY_bLrqWPOmgWwwSTOJh_m55QHAq8UmnqvTTnDju8vbe.KLMaV9yT3Z4A0GzYUSPOz300Ytv51bnyCnDkoH.vTpYeBN362uCmZ0pLBkJNWXL9s2foPzBKfpjQqAcmqyZNlIWOvtYFsAE_ZqaLJMaZJP68Ahb.1yWdKFJ9WNFv2_PzI.eYEU1Of2CVBlekHhcPbIBGkkIJrd7BQLjH5tz64DcCyfU0VjsmgD8vIr1F
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: dedekind@infradead.org
Subject: Re: [patch/rfc 2.6.29 2/2] MTD: support driver model updates
Date: Tue, 31 Mar 2009 22:57:37 -0700
User-Agent: KMail/1.9.10
Cc: Linux MTD <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
References: <200903260039.34013.david-b@pacbell.net> <200903260042.50236.david-b@pacbell.net> <1238564771.20906.26.camel@localhost.localdomain>
In-Reply-To: <1238564771.20906.26.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903312257.37434.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 March 2009, Artem Bityutskiy wrote:
> > --- a/drivers/mtd/nand/mxc_nand.c
> > +++ b/drivers/mtd/nand/mxc_nand.c
> > @@ -866,6 +866,7 @@ static int __init mxcnd_probe(struct pla
> >       mtd = &host->mtd;
> >       mtd->priv = this;
> >       mtd->owner = THIS_MODULE;
> > +     mtd->dev.parent = &pdev->dev;
> 
> Could this be done for all NANDs in nand_base.c instead?

By adding the device as a parameter to nand_scan(),
and presumably nand_scan_ident() ... which is a more
invasive API change, and would require a "flag day"
to convert all drivers.

My default assumption for API changes is to avoid
flag days.  They can be done, yes, but I don't see
a compelling reason to choose one here.

- Dave


