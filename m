Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbZDHV6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbZDHV6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 17:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbZDHV6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 17:58:19 -0400
Received: from brm-mailgate-2.brocade.com ([144.49.197.3]:3616 "EHLO
	brm-mailgate-2.brocade.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752590AbZDHV6S convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 17:58:18 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: bug in drivers/edac/mpc85xx_edac.c:mpc85xx_mc_check() ?
Date: Wed, 8 Apr 2009 14:57:42 -0700
Message-ID: <57AC2FA1761300418C7AB8F3EA493C9702C5F200@HQ-EXCH-5.corp.brocade.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: bug in drivers/edac/mpc85xx_edac.c:mpc85xx_mc_check() ?
Thread-Index: Acm4lQp/520fvHxRSN2NDaRoPxya+Q==
From: "Jeff Haran" <jharan@Brocade.COM>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 08 Apr 2009 21:58:17.0167 (UTC) FILETIME=[1F4EDDF0:01C9B895]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Recent versions of this function start off with:

static void mpc85xx_mc_check(struct mem_ctl_info *mci)
{
    struct mpc85xx_mc_pdata *pdata = mci->pvt_info;
    ...

    err_detect = in_be32(pdata->mc_vbase + MPC85XX_MC_ERR_DETECT);
    if (err_detect)
        return;

    ...
}

My reading of the Freescale 8548E Manual leads me to conclude that the
Memory Error Detect register (ERR_DETECT) will have various bits set if
the memory controller has detected an error since the last time it was
cleared. If no memory error has occurred, the register will contain 0.

Perhaps I am missing something very basic, but it seem to me that the
above "if" should be:

    if (!err_detect)
        return;

as the existing code would seem to read "if any errors have occurred,
ignore them", though perhaps testing has demonstrated that the Freescale
manual is in error.

Please include this email address in responses as I do not subscribe.

Thanks,

Jeff Haran
Brocade
