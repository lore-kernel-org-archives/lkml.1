Return-Path: <linux-kernel-owner+w=401wt.eu-S1759746AbXLLTJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759746AbXLLTJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbXLLTJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:09:36 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:14969 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbXLLTJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:09:34 -0500
To: Or Gerlitz <ogerlitz@voltaire.com>
Cc: Joachim Fenkes <FENKES@de.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Christoph Raisch <raisch@de.ibm.com>,
       OF-General <general@lists.openfabrics.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [ewg] Re: [PATCH] IB/ehca: Serialize HCA-related hCalls on POWER5
X-Message-Flag: Warning: May contain useful information
References: <OFD9564F75.44193623-ONC12573AE.002EA542-C12573AE.002F5FBC@de.ibm.com>
	<475FD0A1.3090304@voltaire.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 12 Dec 2007 11:09:27 -0800
In-Reply-To: <475FD0A1.3090304@voltaire.com> (Or Gerlitz's message of "Wed, 12 Dec 2007 14:14:25 +0200")
Message-ID: <adabq8v91co.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Dec 2007 19:09:28.0721 (UTC) FILETIME=[84C36810:01C83CF2]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > What is the fix you suggest, to add a device query that tells you for 
 > which verbs the documentation does not apply? or enhance the code of the 
 >   map_phys_fmr verb within the ehca driver to return error if called 
 > from non-sleepable context?

I think the right fix for iSER would be to make iSER work even for
devices that don't support FMRs.  For example cxgb3 doesn't implement
FMRs so if anyone ever updates iSER to work on iWARP and not just IB,
then this is something that has to be tackled anyway.  Then ehca could
just get rid of the FMR support it has.
