Return-Path: <linux-kernel-owner+w=401wt.eu-S1030462AbXAaSEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030462AbXAaSEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 13:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030471AbXAaSEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 13:04:42 -0500
Received: from smtp6-g19.free.fr ([212.27.42.36]:50940 "EHLO smtp6-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030464AbXAaSEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 13:04:42 -0500
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: Simon Arlott <99d904aa15c87e3aea1hcjbh0000q9ju@thunder.lp0.eu>
Subject: Re: [PATCH 1/3] usbatm: Allow sub-drivers to handle calls to atm_proc_read.
Date: Wed, 31 Jan 2007 19:04:39 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <45BFB6F1.2070303@simon.arlott.org.uk> <200701311548.13076.duncan.sands@math.u-psud.fr> <45C0D6E0.2090707@simon.arlott.org.uk>
In-Reply-To: <45C0D6E0.2090707@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701311904.39584.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Couldn't the cxacru instance pointer to the proc_read function be set to NULL before unloading?

The problem is reads that started (on some other CPU) before you started shutting things down
(eg: but setting this to null or whatever other method you like) and only finish after you have
finished shutting things down.  Or rather, never finish at all because the code they are executing
has been deleted from the kernel, causing an Oops.  This is not our problem: we can't do anything
about it: remove_proc_entry needs to be fixed so that it waits for all readers/writers of the proc
file to finish before returning, IMO.

Best wishes,

Duncan.
