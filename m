Return-Path: <linux-kernel-owner+w=401wt.eu-S1762575AbXGEXOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762575AbXGEXOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760271AbXGEXOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:14:10 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:35447 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760182AbXGEXOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:14:08 -0400
Subject: Re: [patch 0/3] clean gendisk out of scsi ULD structs
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       akpm@linux-foundation.org, jeff@garzik.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070705230251.GS21478@ftp.linux.org.uk>
References: <20070705140636.6dbabd6f.kristen.c.accardi@intel.com>
	 <20070705230251.GS21478@ftp.linux.org.uk>
Content-Type: text/plain
Date: Thu, 05 Jul 2007 18:14:06 -0500
Message-Id: <1183677246.3448.71.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-06 at 00:02 +0100, Al Viro wrote:
> On Thu, Jul 05, 2007 at 02:06:36PM -0700, Kristen Carlson Accardi wrote:
> > Since gendisk will now become part of struct scsi_device, we don't need
> > to store this value in any private data structs where they already store
> > scsi_device.  This series cleans up a few drivers which did this.
> 
> What the hell?  gendisks are *NOT* supposed to be embedded into other
> data structures, you'll screw up the lifetime rules for them.

Don't panic .. they're not ... we have a pointer to the gendisk in our
SCSI structures (properly refcounted).  The reason is historical and
actually goes back to 2002 when we first got rid of the static arrays of
structures we used to keep around.

Doug ... don't think 'disk' when you see 'gendisk' just think of it as a
useful infrastructure library.

James


