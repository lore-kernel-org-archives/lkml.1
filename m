Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbXCSJZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbXCSJZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 05:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbXCSJZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 05:25:07 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34837 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753356AbXCSJYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 05:24:45 -0400
Date: Mon, 19 Mar 2007 10:24:49 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Eric.Moore@lsi.com
Cc: mpt_linux_developer@lsi.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: drivers/message/fusion/mptsas.c: inconsequent NULL checking
Message-ID: <20070319092449.GM752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted the following inconsequent NULL checking in
drivers/message/fusion/mptsas.c:

<--  snip  -->

...
static void
mptsas_delete_expander_phys(MPT_ADAPTER *ioc)
{
...
                if (port_info->phy_info &&
                    (!(port_info->phy_info[0].identify.device_info &
                    MPI_SAS_DEVICE_INFO_SMP_TARGET)))
                        continue;

                if (mptsas_sas_expander_pg0(ioc, &buffer,
                     (MPI_SAS_EXPAND_PGAD_FORM_HANDLE <<
                     MPI_SAS_EXPAND_PGAD_FORM_SHIFT),
                     port_info->phy_info[0].handle)) {
...

<--  snip  -->

port_info->phy_info is first checked but later dereferenced 
unconditionally.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

