Return-Path: <linux-kernel-owner+w=401wt.eu-S1759457AbZAORBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457AbZAORBD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 12:01:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbZAORAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 12:00:52 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:63699 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754264AbZAORAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 12:00:51 -0500
Subject: Re: [BUILD_FAILURE] next-20090115 - s390x - mm/kmemleak.c
From: Catalin Marinas <catalin.marinas@arm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-s390@vger.kernel.org,
       schwidefsky@de.ibm.com, penberg@cs.helsinki.fi
In-Reply-To: <20090115120526.GD5093@osiris.boeblingen.de.ibm.com>
References: <20090115170415.3edc1df6.sfr@canb.auug.org.au>
	 <20090115103504.GA5178@linux.vnet.ibm.com>
	 <20090115112001.GC5093@osiris.boeblingen.de.ibm.com>
	 <1232020540.32016.19.camel@pc1117.cambridge.arm.com>
	 <20090115120526.GD5093@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 15 Jan 2009 17:00:38 +0000
Message-Id: <1232038838.32016.73.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jan 2009 17:00:39.0313 (UTC) FILETIME=[CAE95810:01C97732]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-15 at 13:05 +0100, Heiko Carstens wrote:
> Btw. you have
> 
> /*
>  * Stop the automatic memory scanning thread. This function must be called
>  * with the kmemleak_mutex held.
>  */
> void stop_scan_thread(void)
> {
> ...
> 
> but call the function unlocked from kmemleak_write. Looks like a bug ;)

kmemleak_write() is called with the kmemleak_mutex acquired in the
kmemleak_open() function (and released in kmemleak_release()).

-- 
Catalin

