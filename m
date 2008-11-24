Return-Path: <linux-kernel-owner+w=401wt.eu-S1753695AbYKXVEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbYKXVEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 16:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbYKXVEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 16:04:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:35692 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbYKXVEh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 16:04:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,661,1220252400"; 
   d="scan'208";a="363825890"
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: Ben Hutchings <bhutchings@solarflare.com>,
       Jan-Bernd Themann <ossthema@de.ibm.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tklein@de.ibm.com" <tklein@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       "jb.billaud@gmail.com" <jb.billaud@gmail.com>,
       "hering2@de.ibm.com" <hering2@de.ibm.com>
Date: Mon, 24 Nov 2008 13:04:33 -0800
Subject: RE: [RFC PATCH] lro: ip fragment checking
Thread-Topic: [RFC PATCH] lro: ip fragment checking
Thread-Index: AclOVOr84U585F5cSvCCirNHQnfJ+QAIuSiA
Message-ID: <F169D4F5E1F1974DBFAFABF47F60C10A1714B0C9@orsmsx507.amr.corp.intel.com>
References: <492ACEC4.3020702@de.ibm.com> <1227545468.3162.4.camel@achroite>
In-Reply-To: <1227545468.3162.4.camel@achroite>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings wrote:
> On Mon, 2008-11-24 at 16:56 +0100, Jan-Bernd Themann wrote:
>> Currently there is no checking in the LRO receive path whether
>> TCP packets are ip fragmented. We should not consider
>> those packets for aggregation.
>> I'm not sure if this checking is actually required. Does anyone
>> know if it is possible to get fragmented TCP packets without
>> the tcp stack changing the MSS size?
>> This patch introduces explicit checking. Any objections?
> 
> LRO depends on the hardware performing TCP checksum offload, and the
> TCP checksum cannot be verified for IP fragments in isolation.  So I
> think drivers should not be passing fragments into inet_lro or should
> reject them in its get_frag_header() or get_skb_header() method. 
> Certainly sfc doesn't pass fragments into inet_lro because they have
> not been checksummed.

The fragments, definitely will not have checksums offloaded, but
what about the first packet in the chain?  I haven't verified in
ixgbe or igb whether or not it could try and aggregate a packet
with MF set if it was the first fragment in a series of IP fragments.