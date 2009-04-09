Return-Path: <linux-kernel-owner+w=401wt.eu-S937436AbZDIXcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937436AbZDIXcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 19:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761999AbZDIXce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 19:32:34 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:42136 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760718AbZDIXcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 19:32:33 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH]Silencing warning: 'host' may be used uninitialized in this function
Date: Fri, 10 Apr 2009 02:31:32 +0300
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <200904100133.58556.mitov@issp.bas.bg> <49DE78E4.2060201@garzik.org>
In-Reply-To: <49DE78E4.2060201@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904100231.32307.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 April 2009 01:38:28 am Jeff Garzik wrote:
> Marin Mitov wrote:
> > Hi all,
> > 
> > I do not know if that is worth the effort, but...
> > 
> > Silencing:  warning: 'host' may be used uninitialized in this function
> > It is a false positive.
> > 
> > The patch is against 2.6.30-rc1, but should apply to 2.6.29(.1) too.
> > 
> > Signed-off-by: Marin Mitov mitov@issp.bas.bg
> > ================================================
> > --- a/drivers/ata/sata_via.c	2009-04-05 22:59:26.000000000 +0300
> > +++ b/drivers/ata/sata_via.c	2009-04-06 00:07:25.000000000 +0300
> > @@ -566,7 +566,7 @@
> >  	static int printed_version;
> >  	unsigned int i;
> >  	int rc;
> > -	struct ata_host *host;
> > +	struct ata_host *host = host;
> >  	int board_id = (int) ent->driver_data;
> >  	const unsigned *bar_sizes;
> 
> we use the uninitialized_var() macro for false positives.
> 
> 	Jeff
> 
 
Well, changed and resubmitted.

Marin Mitov

Silencing: " warning: 'host' may be used uninitialized in this function"

The patch is against 2.6.30-rc1, but should apply to 2.6.29(.1) too.

Signed-off-by: Marin Mitov mitov@issp.bas.bg
================================================
--- a/drivers/ata/sata_via.c	2009-04-05 22:59:26.000000000 +0300
+++ b/drivers/ata/sata_via.c	2009-04-06 00:07:25.000000000 +0300
@@ -566,7 +566,7 @@
 	static int printed_version;
 	unsigned int i;
 	int rc;
-	struct ata_host *host;
+	struct ata_host *uninitialized_var(host);
 	int board_id = (int) ent->driver_data;
 	const unsigned *bar_sizes;
 

