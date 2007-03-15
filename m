Return-Path: <linux-kernel-owner+w=401wt.eu-S1751939AbXCOV5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbXCOV5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 17:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbXCOV5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 17:57:41 -0400
Received: from ns2.suse.de ([195.135.220.15]:35154 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbXCOV5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 17:57:39 -0400
Date: Thu, 15 Mar 2007 22:57:28 +0100
From: Holger Macht <hmacht@suse.de>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Chris Wedgwood <cw@f00f.org>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net
Subject: Re: [PATCH] ACPI: ibm-acpi: allow module to load when acpi notifiers can't be set
Message-ID: <20070315215728.GA15231@homac2>
Mail-Followup-To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	Chris Wedgwood <cw@f00f.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net
References: <20070315071019.GA22613@tuatara.stupidest.org> <20070315175113.GA6596@khazad-dum.debian.net> <20070315191721.GB2556@tuatara.stupidest.org> <20070315123732.2ac478a3.kristen.c.accardi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315123732.2ac478a3.kristen.c.accardi@intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 15. Mar - 12:37:32, Kristen Carlson Accardi wrote:
> On Thu, 15 Mar 2007 12:17:21 -0700
> Chris Wedgwood <cw@f00f.org> wrote:
> 
> > On Thu, Mar 15, 2007 at 02:51:14PM -0300, Henrique de Moraes Holschuh wrote:
> > 
> > > This patch allows for ibm-acpi to coexist (with diminished
> > > functionality) with other drivers like ACPI_BAY.
> > 
> > Given the ACP_IBM_BAY implementation is more complete (or seems to be,
> > please comment if that isn't the case) we should probably actually
> > make sure that is the *preferred* code used (on suitable hardware) at
> > run time surely?
> 
> I haven't followed the ibm_acpi development lately, but when I first
> wrote the bay driver, it had a couple features that ibm_acpi didn't have,
> and then of course, is missing some it does have.  What used to be the
> case is that if bay was inserted after the laptop was booted, the ibm_acpi
> driver would not capture the events because it would only install it's 
> notifier at driver load time on bay devices that existed.  The second
> case is that if you are using the generic dock driver (which is more
> funtional than the ibm_acpi dock feature), for certain ibm laptops such
> as the X60, you need to have undock events sent to the bay device so that
> it can alert user space to unmount cd's etc (since the bay is on the ultrabase).

But there's currently an issue with the second case you're talking
about. The dock driver doesn't generate any event in the bay driver on
undock. And due to the fact that the dock driver automatically issues a
ACPI undock, the hardware indication on the dock station signals
"everything alright" to the user so there's no way to tell the user that
he is not allowed to pull away the docking station because there's still
some file system mounted inside the cdrom. Userspace would need some time
to handle that IMHO.

Just a note,
  Holger

> 
> > 
> > That way distributions can build both options and on IBM/Lenovo
> > hardware it will use the IBM ACPI code and otherwise will use the
> > generic ACPI BAY code?
> 
> I think for now this is a good idea - the ibm_acpi solution should be
> preferred over the generic bay driver till it is more fully developed.
> I don't know how to ensure this is done wrt load order though.
> 
> > 
> > Perhaps the IBM_ACPI_BAY code should go away and any missing
> > functionality provided there should be merged into ACPI_BAY?
> > 
> 
> I think this is a good idea.  It would certainly be less confusing for users.
> too late for this release though, perhaps this can be targetted at 2.6.22/23?
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
