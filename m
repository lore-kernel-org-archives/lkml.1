Return-Path: <linux-kernel-owner+w=401wt.eu-S1760195AbZE2Nms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760195AbZE2Nms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 09:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760103AbZE2Nma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 09:42:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:26614 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760074AbZE2Nm2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 09:42:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,271,1241420400"; 
   d="scan'208";a="519893731"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "neilb@suse.de" <neilb@suse.de>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "maan@systemlinux.org" <maan@systemlinux.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "yur@emcraft.com" <yur@emcraft.com>, "hpa@zytor.com" <hpa@zytor.com>
Date: Fri, 29 May 2009 14:41:39 +0100
Subject: RE: [PATCH v2 02/11] async_tx: kill ASYNC_TX_DEP_ACK flag
Thread-Topic: [PATCH v2 02/11] async_tx: kill ASYNC_TX_DEP_ACK flag
Thread-Index: AcndImA26+0/yMV+TqifrfLJsR710QDMwzcQ
Message-ID: <129600E5E5FB004392DDC3FB599660D7ACC13C6B@irsmsx504.ger.corp.intel.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519005936.4104.58597.stgit@dwillia2-linux.ch.intel.com>
 <f12847240905250320w74897dabo6576b4b48bd19c0c@mail.gmail.com>
In-Reply-To: <f12847240905250320w74897dabo6576b4b48bd19c0c@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
> In support of inter-channel chaining async_tx utilizes an ack flag to
> gate whether a dependent operation can be chained to another.  While the
> flag is not set the chain can be considered open for appending.  Setting
> the ack flag closes the chain and flags the descriptor for garbage
> collection.  The ASYNC_TX_DEP_ACK flag essentially means "close the
> chain after adding this dependency".  Since each operation can only have
> one child the api now implicitly sets the ack flag at dependency
> submission time.  This removes an unnecessary management burden from
> clients of the api.
> 
> [ Impact: clean up and enforce one dependency per operation ]
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  crypto/async_tx/async_memcpy.c |    2 +-
>  crypto/async_tx/async_memset.c |    2 +-
>  crypto/async_tx/async_tx.c     |    4 ++--
>  crypto/async_tx/async_xor.c    |    6 ++----
>  drivers/md/raid5.c             |   25 +++++++++++--------------
>  include/linux/async_tx.h       |    4 +---
>  6 files changed, 18 insertions(+), 25 deletions(-)

Async-tx-api.txt documentation should be also updated
(it still describes ASYNC_TX_DEP_ACK usage).

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
