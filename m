Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbXEMQOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbXEMQOV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 12:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758937AbXEMQOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 12:14:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757745AbXEMQOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 12:14:10 -0400
Date: Sun, 13 May 2007 12:13:53 -0400
From: Dave Jones <davej@redhat.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>,
       William Thompson <wt@electro-mechanical.com>, Mark Lord <liml@rtr.ca>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       albertcc@tw.ibm.com
Subject: Re: [PATCH] libata: fallback to the other IDENTIFY on device error, take#2
Message-ID: <20070513161353.GB29024@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
	William Thompson <wt@electro-mechanical.com>,
	Mark Lord <liml@rtr.ca>, linux-kernel@vger.kernel.org,
	IDE/ATA development list <linux-ide@vger.kernel.org>,
	albertcc@tw.ibm.com
References: <20070501121703.GH5942@electro-mechanical.com> <46373AEE.6070908@rtr.ca> <20070501131818.GA18521@electro-mechanical.com> <46374354.7040307@gmail.com> <20070501172117.GA20328@electro-mechanical.com> <463F56F2.3010106@gmail.com> <4642627A.4030606@garzik.org> <46446311.3000208@gmail.com> <4644E9E5.3000402@garzik.org> <46470B48.7050101@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46470B48.7050101@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2007 at 02:57:44PM +0200, Tejun Heo wrote:
 > Jeff Garzik wrote:
 > > Tejun Heo wrote:
 > >> +            if (class == ATA_DEV_ATA)
 > >> +                class = ATA_DEV_ATAPI;
 > >> +            else
 > >> +                class = ATA_DEV_ATA;
 > > 
 > > 
 > > the 'else' branch is obviously redundant
 > 
 > Why?  We can also fallback from ATAPI to ATA.

Then did you mean to write..

+            if (class == ATA_DEV_ATA)
+                class = ATA_DEV_ATAPI;
+            else if (class == ATA_DEV_ATAPI)
+                class = ATA_DEV_ATA;

?

Otherwise, as Jeff mentions, you're doing a redundant assignment
in the else branch.

	Dave

-- 
http://www.codemonkey.org.uk
