Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbYANT1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbYANT1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYANT1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:27:05 -0500
Received: from relay2.sgi.com ([192.48.171.30]:32985 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752759AbYANT1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:27:04 -0500
Message-ID: <478BB783.6050108@sgi.com>
Date: Mon, 14 Jan 2008 11:26:59 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu, Christoph Lameter <clameter@sgi.com>,
       Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] x86: Change size of APICIDs from u8 to u16
References: <20080113183453.973425000@sgi.com> <20080113183454.155968000@sgi.com> <20080114122310.GC32446@csn.ul.ie>
In-Reply-To: <20080114122310.GC32446@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> On (13/01/08 10:34), travis@sgi.com didst pronounce:
...
>>  int update_end_of_memory(unsigned long end) {return -1;}
>> @@ -343,7 +346,8 @@ int __init acpi_scan_nodes(unsigned long
>>  	/* First clean up the node list */
>>  	for (i = 0; i < MAX_NUMNODES; i++) {
>>  		cutoff_node(i, start, end);
>> -		if ((nodes[i].end - nodes[i].start) < NODE_MIN_SIZE) {
>> +		/* ZZZ why was this needed. At least add a comment */
>> +		if (nodes[i].end && (nodes[i].end - nodes[i].start) < NODE_MIN_SIZE) {
> 
> Care to actually add a comment? This looks like a note to yourself that
> got missed.

Oops, sorry, missed this the first time.

Actually that was a note from someone else and I didn't address it. 
(Weirdly, I had removed it but some quilt refresh demon brought it back. ;-)

We found this error in testing with a virtual BIOS but I think we
never figured out if it was an error in our BIOS or a valid error. 
But in any case, I'll fix it.

Thanks,
Mike
