Return-Path: <linux-kernel-owner+w=401wt.eu-S1751087AbZIHPsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751087AbZIHPsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 11:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750890AbZIHPso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 11:48:44 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58606 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750877AbZIHPso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 11:48:44 -0400
Subject: Re: linux-next: scsi-post-merge tree build failure
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jayamohan Kallickal <jayamohank@serverengines.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <20090908181221.e8f98215.sfr@canb.auug.org.au>
References: <20090907200646.c6d6fadc.sfr@canb.auug.org.au>
	 <20090908181221.e8f98215.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Tue, 08 Sep 2009 10:48:43 -0500
Message-Id: <1252424923.3990.204.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 18:12 +1000, Stephen Rothwell wrote:
> Hi James,
> 
> On Mon, 7 Sep 2009 20:06:46 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Today's linux-next build (powerpc allyesconfig) failed like this:
> > 
> > drivers/scsi/be2iscsi/be_main.c: In function 'hwi_write_buffer':
> > drivers/scsi/be2iscsi/be_main.c:1481: error: implicit declaration of function 'virt_to_bus'
> > 
> > Caused by commit 9316dc3deb9675c674f96a0c6fb74ccc6c497fae ("[SCSI]
> > be2iscsi: add 10Gbps iSCSI - BladeEngine 2 driver") which I have reverted
> > for today.
> 
> The driver needs to depend on CONFIG_VIRT_TO_BUS if it needs to use
> virt_to_bus().  That will prevent it from building on some platforms
> (like powerpc) that do not implement virt_to_bus() and its brothers.

Actually, this is a modern hardware iSCSI card not some legacy piece of
hardware: it needs to use the proper API for this.

James


