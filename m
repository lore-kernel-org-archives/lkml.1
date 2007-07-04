Return-Path: <linux-kernel-owner+w=401wt.eu-S1759786AbXGDKIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759786AbXGDKIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 06:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758318AbXGDKIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 06:08:40 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:52194 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757266AbXGDKIk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 06:08:40 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Wed, 4 Jul 2007 12:08:40 +0200
User-Agent: KMail/1.9.7
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>
References: <20070703042916.GA17240@srcf.ucam.org> <200707041039.30015.oliver@neukum.org> <18059.26259.765791.62319@cargo.ozlabs.ibm.com>
In-Reply-To: <18059.26259.765791.62319@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707041208.40735.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 4. Juli 2007 schrieb Paul Mackerras:
> Oliver Neukum writes:
> 
> > > It's not lost, it's sitting in RAM, and will be sent out when you
> > > resume.
> > 
> > Unfortunately this is not the case. The URB will error out.
> 
> So the higher-level driver needs to do the sensible thing, i.e.,
> resubmit the URB after resume.  It's not rocket science.  The data is
> not lost, it's sitting in RAM, and the higher-level driver will send
> it out when you resume.  If not, then we fix the higher-level driver.

You cannot simply restart the URB without thinking.
The device after resumption may or may not be in the stage
you left it. It needs to be rechecked and some settings must be
renewed. You cannot simple throw an URB from an arbitrary
stage of the protocol at it.
Suspension of devices can only happen at some points
in the protocol.

	Oliver

