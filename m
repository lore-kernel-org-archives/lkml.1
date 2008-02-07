Return-Path: <linux-kernel-owner+w=401wt.eu-S933214AbYBGWER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214AbYBGWER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757825AbYBGWEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:04:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756993AbYBGWD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:03:58 -0500
Message-ID: <47AB803F.7070208@redhat.com>
Date: Thu, 07 Feb 2008 17:03:43 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: "Yang, Bo" <Bo.Yang@lsi.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Scott Shambarger <scott-lkml@shambarger.net>,
       linux-kernel@vger.kernel.org, "Patro, Sumant" <Sumant.Patro@lsi.com>,
       linux-scsi@vger.kernel.org, DL-MegaRAID Linux <megaraidlinux@lsi.com>,
       "Kolli, Neela" <Neela.Kolli@lsi.com>
Subject: Re: Oops in megaraid_mbox_dpc(), kernel 2.6.23.9-85.fc8.i686
References: <9738BCBE884FDB42801FAD8A7769C26501EE201D@NAMAIL1.ad.lsil.com>
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C26501EE201D@NAMAIL1.ad.lsil.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2008 02:38 PM, Yang, Bo wrote:
> Andrew/Scott,
> 
> Can you give me more details about this issue?  Such as: MegaRAID
> Controller name, FW version, RAID configuration, host system info, how
> to reproduce this issue.  Also do you see the issue on other kernel
> versions.  
> 

He has hit the BUG() here in megaraid_mbox_dpc():

                // Make sure f/w has completed a valid command
                if (scb->state != SCB_ISSUED) {
                        con_log(CL_ANN, (KERN_CRIT
                        "megaraid critical err: invalid command %d:%d:%p\n",
                                scb->sno, scb->state, scp));
                        BUG();
                        continue;       // Must never happen!
                }
