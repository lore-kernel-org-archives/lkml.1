Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbZKPOtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbZKPOtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbZKPOtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:49:32 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:56728 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbZKPOtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:49:31 -0500
Subject: Re: PCI: pci_restore_state() is returning 0 when it fails
From: Ben Hutchings <bhutchings@solarflare.com>
To: Breno Leitao <leitao@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-net-drivers@solarflare.com
In-Reply-To: <4B015E0C.9030904@linux.vnet.ibm.com>
References: <4AFD91DD.7000104@linux.vnet.ibm.com>
	 <200911132108.56691.rjw@sisk.pl>  <4B015E0C.9030904@linux.vnet.ibm.com>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Mon, 16 Nov 2009 14:49:34 +0000
Message-Id: <1258382974.2841.23.camel@achroite.uk.solarflarecom.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Nov 2009 14:49:37.0645 (UTC) FILETIME=[04FBC1D0:01CA66CC]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.000.1038-17012.004
X-TM-AS-Result: No--35.585200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-16 at 12:13 -0200, Breno Leitao wrote:
> Hi Rafael, 
> 
> Rafael J. Wysocki wrote:
> > On Friday 13 November 2009, Breno Leitao wrote:
> >> Actually pci_restore_state() is returning 0 if the restore process
> >> fails, instead of a error value.
> >>
> >> If it fails, I believe that it should return -EPERM, once that
> >> it is an invalid operation and probably pci_save_state() wasn't
> >> called.
> > 
> > I believe this patch will break a number of things.
> Well, I checked it, and found that there are around 10 places that
> really verify the return value for this function, and almost all of them
> do the correct thing, and the patch doesn't seem to break any of them
> except a specific case in the drivers/net/sfc/falcon.c file, that contains:
[...]
> That's because the code is calling pci_restore_state() twice without calling
> pci_save_state() in the middle. 
> Since this seems to be the only place that will be broken, and the fix is
> trivial, I believe that the patch can be applied smoothly.
[...]

This code supports two similar PCI devices, one of which has a second
function that is not truly independent.  For that chip it saves and
restores both functions' config space.  So far as I know, there are no
cases where it fails to match save and restore.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

