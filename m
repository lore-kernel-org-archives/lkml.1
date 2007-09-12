Return-Path: <linux-kernel-owner+w=401wt.eu-S969794AbXILOnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969794AbXILOnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 10:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965057AbXILOmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 10:42:54 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:43119 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966815AbXILOmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 10:42:54 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: Nathan Lynch <ntl@pobox.com>
Subject: Re: [PATCH 08/12] IB/ehca: Replace get_paca()->paca_index by the more portable smp_processor_id()
Date: Wed, 12 Sep 2007 16:42:50 +0200
User-Agent: KMail/1.8.2
Cc: LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       OF-General <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, OF-EWG <ewg@lists.openfabrics.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>
References: <200709111518.26276.fenkes@de.ibm.com> <200709111533.14333.fenkes@de.ibm.com> <20070911145131.GN32388@localdomain>
In-Reply-To: <20070911145131.GN32388@localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709121642.51198.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 September 2007 16:51, Nathan Lynch wrote:

> > -				   get_paca()->paca_index, __FUNCTION__, \
> > +				   smp_processor_id(), __FUNCTION__, \
> 
> I think I see these macros used in preemptible code (e.g. ehca_probe),
> where smp_processor_id() will print a warning when
> CONFIG_DEBUG_PREEMPT=y.  Probably better to use raw_smp_processor_id.

You're right, man. The processor id doesn't need to be preemption-safe in this
context, so that would be a bogus warning. Thanks for pointing this out. I'll
post a new version of this patch.

Joachim

