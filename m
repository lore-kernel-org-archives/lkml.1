Return-Path: <linux-kernel-owner+w=401wt.eu-S933211AbXCOTkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211AbXCOTkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933228AbXCOTkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:40:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:1178 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933211AbXCOTk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:40:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,289,1170662400"; 
   d="scan'208"; a="197118721:sNHT64486016"
Date: Thu, 15 Mar 2007 12:37:32 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Chris Wedgwood <cw@f00f.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       ibm-acpi-devel@lists.sourceforge.net
Subject: Re: [PATCH] ACPI: ibm-acpi: allow module to load when acpi
 notifiers can't be set
Message-Id: <20070315123732.2ac478a3.kristen.c.accardi@intel.com>
In-Reply-To: <20070315191721.GB2556@tuatara.stupidest.org>
References: <20070315071019.GA22613@tuatara.stupidest.org>
	<20070315175113.GA6596@khazad-dum.debian.net>
	<20070315191721.GB2556@tuatara.stupidest.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007 12:17:21 -0700
Chris Wedgwood <cw@f00f.org> wrote:

> On Thu, Mar 15, 2007 at 02:51:14PM -0300, Henrique de Moraes Holschuh wrote:
> 
> > This patch allows for ibm-acpi to coexist (with diminished
> > functionality) with other drivers like ACPI_BAY.
> 
> Given the ACP_IBM_BAY implementation is more complete (or seems to be,
> please comment if that isn't the case) we should probably actually
> make sure that is the *preferred* code used (on suitable hardware) at
> run time surely?

I haven't followed the ibm_acpi development lately, but when I first
wrote the bay driver, it had a couple features that ibm_acpi didn't have,
and then of course, is missing some it does have.  What used to be the
case is that if bay was inserted after the laptop was booted, the ibm_acpi
driver would not capture the events because it would only install it's 
notifier at driver load time on bay devices that existed.  The second
case is that if you are using the generic dock driver (which is more
funtional than the ibm_acpi dock feature), for certain ibm laptops such
as the X60, you need to have undock events sent to the bay device so that
it can alert user space to unmount cd's etc (since the bay is on the ultrabase).

> 
> That way distributions can build both options and on IBM/Lenovo
> hardware it will use the IBM ACPI code and otherwise will use the
> generic ACPI BAY code?

I think for now this is a good idea - the ibm_acpi solution should be
preferred over the generic bay driver till it is more fully developed.
I don't know how to ensure this is done wrt load order though.

> 
> Perhaps the IBM_ACPI_BAY code should go away and any missing
> functionality provided there should be merged into ACPI_BAY?
> 

I think this is a good idea.  It would certainly be less confusing for users.
too late for this release though, perhaps this can be targetted at 2.6.22/23?
