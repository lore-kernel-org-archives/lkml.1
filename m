Return-Path: <linux-kernel-owner+w=401wt.eu-S1758448AbYFEPLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758448AbYFEPLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 11:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbYFEPLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 11:11:43 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:7354 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbYFEPLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 11:11:42 -0400
Date: Thu, 5 Jun 2008 09:11:40 -0600
From: Alex Chiang <achiang@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, jbarnes@virtuousgeek.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Wilcox <matthew@wil.cx>, kristen.c.accardi@intel.com,
       greg@kroah.com, lenb@kernel.org, pbadari@us.ibm.com,
       linux-pci@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kobject: Export kobject_rename for pci_hotplug_core
Message-ID: <20080605151140.GA12991@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	jbarnes@virtuousgeek.org,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Matthew Wilcox <matthew@wil.cx>, kristen.c.accardi@intel.com,
	greg@kroah.com, lenb@kernel.org, pbadari@us.ibm.com,
	linux-pci@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
References: <20080604200829.GC379@ldl.fc.hp.com> <20080604201606.GE379@ldl.fc.hp.com> <20080604224838.6b556a51.akpm@linux-foundation.org> <48478247.30809@jp.fujitsu.com> <20080604233348.eb46d8de.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080604233348.eb46d8de.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org>:
> On Thu, 05 Jun 2008 15:05:59 +0900 Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> wrote:
> 
> > Andrew Morton wrote:
> > > On Wed, 4 Jun 2008 14:16:06 -0600 Alex Chiang <achiang@hp.com> wrote:
> > > 
> > >> From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> > >>
> > >> Export kobject_rename() to fix the following link error.  This happens when
> > >> pci_hotplug_core driver is compiled as a kernel module.
> > >>
> > >> ERROR: "kobject_rename" [drivers/pci/hotplug/pci_hotplug.ko] undefined!
> > >> make[1]: *** [__modpost] Error 1
> > >> make: *** [modules] Error 2
> > >> make: *** Waiting for unfinished jobs....
> > >>
> > >> Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> > >> Acked-by: Alex Chiang <achiang@hp.com>
> > >> Cc: Greg KH <greg@kroah.com>
> > >> Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> > >> Cc: Len Brown <lenb@kernel.org>
> > >> Signed-off-by: Alex Chiang <achiang@hp.com>
> > >> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > >> ---
> > >>  lib/kobject.c |    1 +
> > >>  1 files changed, 1 insertions(+), 0 deletions(-)
> > >>
> > >> diff --git a/lib/kobject.c b/lib/kobject.c
> > >> index 718e510..dcade05 100644
> > >> --- a/lib/kobject.c
> > >> +++ b/lib/kobject.c
> > >> @@ -439,6 +439,7 @@ out:
> > >>  
> > >>  	return error;
> > >>  }
> > >> +EXPORT_SYMBOL_GPL(kobject_rename);
> > > 
> > > Shouldn't this go straight into 2.6.26?

Originally, gregkh told me "no" because then he would have to
deal with a bunch of patching removing an unused interface, which
is why it showed up as a separate patch in my series.

> > I think "No", because currently its only required by Alex's "pci slot"
> > patches.
> 
> In that case the fix should be integrated into the patch which it is
> fixing.
> 
> Well, it doesn't _have_ to be integrated because in this case it can
> precede acpi-pci-slot-detection-driver.patch.  But we might as well
> fold it, to keep the commit noise level down.

Ok, that makes sense to me.

/ac

