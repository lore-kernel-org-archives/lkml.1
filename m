Return-Path: <linux-kernel-owner+w=401wt.eu-S1761587AbZFKB4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761587AbZFKB4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 21:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756391AbZFKB4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 21:56:11 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:40974 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755969AbZFKB4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 21:56:09 -0400
Subject: Re: [PATCH] Re:[BUILD FAILURE 04/04] Next June 04:PPC64 randconfig
	[drivers/net/ucc_geth.o]
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Stephen Rothwell <sfr@canb.auug.org.au>, netdev@vger.kernel.org,
       Li Yang <leoli@freescale.com>
Cc: Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Linux-Next <linux-next@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>
In-Reply-To: <20090611110523.1fd56a41.sfr@canb.auug.org.au>
References: <20090610174323.28045.70169.sendpatchset@subratamodak.linux.ibm.com>
	 <20090611110523.1fd56a41.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Organization: IBM
Date: Thu, 11 Jun 2009 07:26:04 +0530
Message-Id: <1244685364.6494.14.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-11 at 11:05 +1000, Stephen Rothwell wrote:
> Hi Subrata,
> 
> On Wed, 10 Jun 2009 23:13:23 +0530 Subrata Modak <subrata@linux.vnet.ibm.com> wrote:
> >
> >  	/* Find the TBI PHY.  If it's not there, we don't support SGMII */
> > -	ph = of_get_property(np, "tbi-handle", NULL);
> > +	ph = (phandle *)of_get_property(np, "tbi-handle", NULL);
> 
> You don't need this cast because of_get_property() returns "void *".

Stephen,

True. But without this gcc complains:

CC [M]  drivers/net/ucc_geth.o
drivers/net/ucc_geth.c: In function ‘ucc_geth_probe’:
drivers/net/ucc_geth.c:3824: warning: assignment discards qualifiers
from pointer target type

Else gcc just builds fine:

CC [M]  drivers/net/ucc_geth.o

This is an just an extra caution to fix both the build and warning
regression(s).

Regards--
Subrata

> 

