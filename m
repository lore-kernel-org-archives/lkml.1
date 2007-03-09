Return-Path: <linux-kernel-owner+w=401wt.eu-S1752715AbXCISdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbXCISdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 13:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbXCISdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 13:33:18 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:52394 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbXCISdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 13:33:17 -0500
Date: Fri, 9 Mar 2007 10:26:51 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, kjhall@linux.vnet.ibm.com, zohar@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] [Patch 1/1] IBAC Patch
Message-Id: <20070309102651.6365b76e.randy.dunlap@oracle.com>
In-Reply-To: <1173446376.24710.0.camel@localhost.localdomain>
References: <1173394696.5981.12.camel@localhost.localdomain>
	<20070308150839.7c191323.randy.dunlap@oracle.com>
	<1173446376.24710.0.camel@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Mar 2007 08:19:36 -0500 Mimi Zohar wrote:

> On Thu, 2007-03-08 at 15:08 -0800, Randy Dunlap wrote:
> > On Thu, 08 Mar 2007 17:58:16 -0500 Mimi Zohar wrote:
> > 
> > > This is a request for comments for a new Integrity Based Access
> > > Control(IBAC) LSM module which bases access control decisions
> > > on the new integrity framework services. 
> > > 
> > > (Hopefully this will help clarify the interaction between an LSM 
> > > module and LIM module.)
> > > 
> > > Index: linux-2.6.21-rc3-mm2/security/ibac/Kconfig
> > > ===================================================================
> > > --- /dev/null
> > > +++ linux-2.6.21-rc3-mm2/security/ibac/Kconfig
> > > @@ -0,0 +1,36 @@
> > > +config SECURITY_IBAC
> > > +	boolean "IBAC support"
> > > +	depends on SECURITY && SECURITY_NETWORK && INTEGRITY
> > > +	help
> > > +	  Integrity Based Access Control(IBAC) implements integrity
> > > +	  based access control.
> > 
> > Please make the help text do more than repeat the words I B A C...
> > Put a short explanation or say something like:
> > 	  See Documentation/security/foobar.txt for more information.
> > (and add that file)
> 
> Agreed.  Perhaps something like:
> 
> Integrity Based Access Control(IBAC) uses the Linux Integrity
> Module(LIM) API calls to verify an executable's metadata and 
> data's integrity.  Based on the results, execution permission 
> is permitted/denied.  Integrity providers may implement the 
> LIM hooks differently.  For more information on integrity
> verification refer to the specific integrity provider 
> documentation. 

Yes, thanks.

> > > +config SECURITY_IBAC_BOOTPARAM
> > > +	bool "IBAC boot parameter"
> > > +	depends on SECURITY_IBAC
> > > +	default y
> > > +	help
> > > +	  This option adds a kernel parameter 'ibac', which allows IBAC
> > > +	  to be disabled at boot.  If this option is selected, IBAC
> > > +	  functionality can be disabled with ibac=0 on the kernel
> > > +	  command line.  The purpose of this option is to allow a
> > > +	  single kernel image to be distributed with IBAC built in,
> > > +	  but not necessarily enabled.
> > > +
> > > +	  If you are unsure how to answer this question, answer N.
> > 
> > What's the downside to having this always builtin instead of
> > yet another config option?
> 
> The ability of changing LSM modules at runtime might be perceived
> as problematic.
> 
> > > +static struct security_operations ibac_security_ops = {
> > > +	.bprm_check_security = ibac_bprm_check_security
> > > +};
> > > +
> > > +static int __init init_ibac(void)
> > > +{
> > > +	int rc;
> > > +
> > > +	if (!ibac_enabled)
> > > +		return 0;
> > > +
> > > +	rc = register_security(&ibac_security_ops);
> > > +	if (rc != 0)
> > > +		panic("IBAC: Unable to register with kernel\n");
> > 
> > Normally we would not want to see a panic() from a register_xyz()
> > failure, but I guess you are arguing that an ibac register_security()
> > failure needs to halt everything??
> 
> Yes, as this implies that another LSM module registered the hooks first,
> preventing IBAC from registering itself. 
> 
> Thank you for your other comments.  They'll be addressed in the next
> ibac patch release.

Okie.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
