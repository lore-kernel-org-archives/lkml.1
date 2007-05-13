Return-Path: <linux-kernel-owner+w=401wt.eu-S1759633AbXEMSp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759633AbXEMSp2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 14:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757877AbXEMSpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 14:45:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757674AbXEMSpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 14:45:19 -0400
Date: Sun, 13 May 2007 14:45:04 -0400
From: Dave Jones <davej@redhat.com>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
Subject: Re: why does x86 "make defconfig" build a single, lonely module?
Message-ID: <20070513184504.GH27604@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Simon Arlott <simon@fire.lp0.eu>,
	James Bottomley <James.Bottomley@SteelEye.com>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-scsi@vger.kernel.org
References: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain> <20070513160608.GA29024@redhat.com> <1179072655.3723.42.camel@mulgrave.il.steeleye.com> <Pine.LNX.4.64.0705131216440.27468@localhost.localdomain> <1179073670.3723.48.camel@mulgrave.il.steeleye.com> <46474E1A.6080904@simon.arlott.org.uk> <1179078537.3723.53.camel@mulgrave.il.steeleye.com> <46475857.4010509@simon.arlott.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46475857.4010509@simon.arlott.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2007 at 07:26:31PM +0100, Simon Arlott wrote:

 > It looks like SCSI_WAIT_SCAN is pointless unless SCSI_SCAN_ASYNC 
 > is selected - so it should depend on it:
 > 
 > ---
 > diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
 > index e62d23f..0f6c370 100644
 > --- a/drivers/scsi/Kconfig
 > +++ b/drivers/scsi/Kconfig
 > @@ -244,7 +244,7 @@ config SCSI_SCAN_ASYNC
 >  config SCSI_WAIT_SCAN
 >  	tristate
 >  	default m
 > -	depends on SCSI
 > +	depends on SCSI_SCAN_ASYNC
 >  	depends on MODULES
 >  
 >  menu "SCSI Transports"

This is the same broken patch that I posted earlier in this thread.
See James' follow-ups to my mail.

	Dave

-- 
http://www.codemonkey.org.uk
