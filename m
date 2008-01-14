Return-Path: <linux-kernel-owner+w=401wt.eu-S1753525AbYANSdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbYANSdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 13:33:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750875AbYANSc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 13:32:58 -0500
Received: from relay1.sgi.com ([192.48.171.29]:41308 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750824AbYANSc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 13:32:57 -0500
Message-ID: <478BAAD5.1090500@sgi.com>
Date: Mon, 14 Jan 2008 10:32:53 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu, Christoph Lameter <clameter@sgi.com>,
       Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] x86: Change size of APICIDs from u8 to u16
References: <20080113183453.973425000@sgi.com> <20080113183454.155968000@sgi.com> <Pine.LNX.4.64.0801141908370.24893@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0801141908370.24893@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
...
 
>> --- a/arch/x86/mm/srat_64.c
>> +++ b/arch/x86/mm/srat_64.c
>> @@ -384,6 +388,12 @@ int __init acpi_scan_nodes(unsigned long
>> }
>>
>> #ifdef CONFIG_NUMA_EMU
>> +static int fake_node_to_pxm_map[MAX_NUMNODES] __initdata = {
>> +	[0 ... MAX_NUMNODES-1] = PXM_INVAL
>> +};
>> +static unsigned char fake_apicid_to_node[MAX_LOCAL_APIC] __initdata = {
>> +	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
>> +};
>> static int __init find_node_by_addr(unsigned long addr)
>> {
>> 	int ret = NUMA_NO_NODE;
> 
> No u8/u16 here?

I see the mistake in the node array.  But AFAICT, pxm is the proximity
between nodes and cannot be expressed as greater than the number of
nodes, yes?  (Or can it be arbitrarily expressed where 32 bits is
necessary?)  I ask this because the real node_to_pxm_map is already
32 bits.

Thanks,
Mike


