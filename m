Return-Path: <linux-kernel-owner+w=401wt.eu-S1751896AbYIJSLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbYIJSLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 14:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbYIJSLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 14:11:07 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:2225 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751057AbYIJSLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 14:11:06 -0400
Message-ID: <48C80C11.9080103@panasas.com>
Date: Wed, 10 Sep 2008 21:04:01 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Chris Leech <christopher.leech@intel.com>
CC: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [Open-FCoE] [PATCH 1/3] 24-bit types: typedef and macros for
 accessing 3-byte arrays as integers
References: <20080905165732.16689.50256.stgit@localhost.localdomain>		<20080910140712.GA12280@infradead.org>	<1221061241.27385.14.camel@norville.austin.ibm.com> <48C7F4EC.1080709@intel.com> <48C807A9.60509@intel.com>
In-Reply-To: <48C807A9.60509@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Sep 2008 18:03:08.0053 (UTC) FILETIME=[7ADF6C50:01C9136F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Leech wrote:
> Chris Leech wrote:
>> Dave Kleikamp wrote:
>>> @@ -62,7 +60,7 @@ struct timestruc_t {
>>>   */
>>>  typedef struct {
>>>  	unsigned len:24;
>>> -	unsigned off1:8;
>>> +	u8 off1;
>>>  	u32 off2;
>>>  } lxd_t;
>> Shouldn't len here be changed to a __le24?  I think this just changed
>> the size of lxd_t by a byte.
> 
> Never mind, I see that it's a host order field.  And presently surprised
> to see that gcc combines the 24-bit bitfield with the following u8.
> 
> Chris

It does because these are all bytes. on x86. But this is not guarantied
for all ARCHs and machine-word-sizes. In any way this should be consistent
with the rest of the file.

Please see my other reply about packing of structures. If this is
on-the-wire then there are problems.

Boaz
