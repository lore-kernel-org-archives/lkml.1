Return-Path: <linux-kernel-owner+w=401wt.eu-S1751860AbXLJRmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbXLJRmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 12:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbXLJRmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 12:42:08 -0500
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:15891 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbXLJRmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 12:42:07 -0500
From: Joachim Fenkes <fenkes@de.ibm.com>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH] IB/ehca: Serialize HCA-related hCalls on POWER5
Date: Mon, 10 Dec 2007 18:41:29 +0100
User-Agent: KMail/1.9.1
Cc: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org,
       LKML <linux-kernel@vger.kernel.org>, OF-EWG <ewg@lists.openfabrics.org>,
       Christoph Raisch <raisch@de.ibm.com>, Marcus Eder <meder@de.ibm.com>,
       OF-General <general@lists.openfabrics.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200712061607.20004.fenkes@de.ibm.com> <200712071058.38416.arnd@arndb.de> <adaodcza1xc.fsf@cisco.com>
In-Reply-To: <adaodcza1xc.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712101841.30010.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 December 2007 00:22, Roland Dreier wrote:
> Fair enough... according to Documentation/infiniband/core_locking.txt,
> the only driver methods that cannot sleep are:
> 
>     [...]
>     map_phys_fmr

In fact, we do use hCalls there. Our hardware doesn't actually support FMRs,
so we translate a "map FMR" into a "reallocate PMR", which doesn't work
without hCalls. What's more, the hCalls involved (e.g. H_FREE_RESOURCE)
might well return H_LONG_BUSY, so the whole operation might sleep; no way
around it.

How should we deal with this?

Thanks,
  Joachim

