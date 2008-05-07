Return-Path: <linux-kernel-owner+w=401wt.eu-S1763348AbYEGPce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763348AbYEGPce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 11:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760754AbYEGPcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 11:32:09 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:37014 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761523AbYEGPcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 11:32:05 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>, fenkes@de.ibm.com,
       raisch@de.ibm.com
Subject: Re: [ewg] [PATCH] IB/ehca: Protect QP against destroying until all async events for it are handled.
References: <200805071319.37164.ossrosch@linux.vnet.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 07 May 2008 08:32:03 -0700
In-Reply-To: <200805071319.37164.ossrosch@linux.vnet.ibm.com> (Stefan
	Roscher's message of "Wed, 7 May 2008 13:19:35 +0200")
Message-ID: <adahcdaw2oc.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 May 2008 15:32:03.0490 (UTC) FILETIME=[7FEC6020:01C8B057]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > We are not sure if this should be fixed in the driver or in uverbs itself.
 > Roland, what's your opinion about this?

Would be nice to be able to fix it in uverbs but I don't see how.  In
particular a kernel consumer has to have the same guarantee that no
async events will come in after destroy QP returns.  And I don't see any
way generic code can provide a guarantee about what low-level driver
code may do internally.
