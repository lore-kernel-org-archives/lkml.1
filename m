Return-Path: <linux-kernel-owner+w=401wt.eu-S1759377AbXH3R45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377AbXH3R45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 13:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759515AbXH3R4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 13:56:33 -0400
Received: from sceptre.pobox.com ([207.106.133.20]:58067 "EHLO
	sceptre.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759163AbXH3R4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 13:56:31 -0400
Date: Thu, 30 Aug 2007 12:56:09 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Joachim Fenkes <FENKES@de.ibm.com>
Cc: jschopp <jschopp@austin.ibm.com>, Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       Paul Mackerras <paulus@samba.org>, Paul Mackerras <pmac@au1.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Thomas Q Klein <tklein@de.ibm.com>
Subject: Re: [PATCH 2.6.23] ibmebus: Prevent bus_id collisions
Message-ID: <20070830175609.GG23140@localdomain>
References: <46D5BBFA.5060200@austin.ibm.com> <OF9D1ED44F.896DCCC5-ONC1257347.0044D256-C1257347.004CFB07@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF9D1ED44F.896DCCC5-ONC1257347.0044D256-C1257347.004CFB07@de.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joachim-

Joachim Fenkes wrote:
> Nathan Lynch <ntl@pobox.com> wrote on 29.08.2007 20:12:32:
> > Will anything break?
> 
> Nope. Userspace programs should not depend on ibmebus' way of naming the 
> devices; especially since some overly long loc_codes tended to be 
> truncated and thus rendered useless. I have tested IBM's DLPAR tools 
> against the changed kernel, and they didn't break.

Okay.


> > Also, I dislike this approach of duplicating the firmware device tree
> > path in sysfs.
> 
> Why? Any specific reasons for your dislike?

struct device's bus_id field is but 20 bytes in size.  Too close for
comfort?


> > Are GX/ibmebus devices guaranteed to be children of
> > the same node in the OF device tree?  If so, their unit addresses will
> > be unique, and therefore suitable values for bus_id.  I believe this
> > is what the powerpc vio bus code does.
> 
> While there's no such guarantee (as in "officially signed document"), yes, 
> I expect future GX devices to also appear beneath the OFDT root node. For 
> the existing devices, the unit addresses are already part of the device 
> name, so I save the need to use sprintf() again. Plus, I rather like using 
> the full_name since it also contains a descriptive name as opposed to 
> being just nondescript numbers, helping the layman (ie user) to make sense 
> out of a dev_id.

Okay, but your layman isn't supposed to be relying on any
user-friendly properties of the name :) Hope he doesn't work on a
distro installer.

Anyway, if you're still confident in this approach, I relent.  :)
