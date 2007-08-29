Return-Path: <linux-kernel-owner+w=401wt.eu-S1759230AbXH2SNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbXH2SNB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 14:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbXH2SMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 14:12:52 -0400
Received: from sceptre.pobox.com ([207.106.133.20]:37865 "EHLO
	sceptre.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbXH2SMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 14:12:51 -0400
Date: Wed, 29 Aug 2007 13:12:32 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Thomas Klein <tklein@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 2.6.23] ibmebus: Prevent bus_id collisions
Message-ID: <20070829181232.GB23140@localdomain>
References: <200708291815.18197.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708291815.18197.fenkes@de.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi-

Joachim Fenkes wrote:
> Previously, ibmebus derived a device's bus_id from its location code. The
> location code is not guaranteed to be unique, so we might get bus_id
> collisions if two devices share the same location code. The OFDT full_name,
> however, is unique, so we use that instead.

This is a userspace-visible change, but I guess it's unavoidable.
Will anything break?

Also, I dislike this approach of duplicating the firmware device tree
path in sysfs.  Are GX/ibmebus devices guaranteed to be children of
the same node in the OF device tree?  If so, their unit addresses will
be unique, and therefore suitable values for bus_id.  I believe this
is what the powerpc vio bus code does.

