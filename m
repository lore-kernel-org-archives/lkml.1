Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbYIZGDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbYIZGDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 02:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbYIZGCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 02:02:54 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41713 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750886AbYIZGCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 02:02:53 -0400
Subject: RE: [PATCH 5/6] bfa: Brocade BFA FC SCSI driver submission (2ndtry)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jing Huang <huangj@Brocade.COM>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Ramkumar Vadivelu <rvadivel@Brocade.COM>,
       "Srikanth Rayas (CW)" <srayas@Brocade.COM>,
       Vinodh Ravindran <vravindr@Brocade.COM>
In-Reply-To: <4C94DE2070B172459E4F1EE14BD2364E01F28079@HQ-EXCH-5.corp.brocade.com>
References: <200809260106.m8Q160kj028501@swe37.brocade.com>
	 <20080926025514.GD9480@kroah.com>
	 <4C94DE2070B172459E4F1EE14BD2364E01F28079@HQ-EXCH-5.corp.brocade.com>
Content-Type: text/plain
Date: Thu, 25 Sep 2008 23:02:17 -0700
Message-Id: <1222408937.3265.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-25 at 21:49 -0700, Jing Huang wrote:
> The reason we creating our own sysfs directory under /sys/devices path
> was we felt the fc transport and scsi host attributes are not enough for
> all the HBA management features we want to have.

This isn't really a valid reason.  We use the fc transport class to
share infrastructure and provide a common interface for users.  If you
need more, we can discuss adding features to the fc transport class if
they would be useful to fibre drivers in general.  If they're not useful
to other drivers, then you can add pieces specific to your driver for
them, but the functionality that's already in the fc transport shouldn't
be duplicated by that.

>  We have ioctl in our
> non opensource driver, and we want to have something to emulate all/most
> of the IOCTL functionality we have in the opensource driver. We provide
> multi-level of driver/fw statistics info to the user, and we want to put
> those info under a separate directory instead of throw them all under
> scsi_host.

That's how the fc transport class currently operates.  It's statistics
all appear in a "statistics" directory under the host.  If you use it
(and add the ones you need that are missing) everyone will be happy and
you won't need to worry about creating the directories.

>  I just didn't know how to create a subdirectory under scsi/fc
> host. Currently, we only implement a small portion of all the IOCTL
> functionalities. We want to know if this is acceptable in the upstream
> kernel. 
> 
> I agree that there are a lot of redundancy with the attributes we
> created under scsi_host. We will clean them up.

James


