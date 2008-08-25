Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbYHYD2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbYHYD2e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 23:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYHYD2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 23:28:25 -0400
Received: from brinza.cc.columbia.edu ([128.59.29.8]:35195 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbYHYD2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 23:28:25 -0400
Message-ID: <48B226CE.2060700@cs.columbia.edu>
Date: Sun, 24 Aug 2008 23:28:14 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Louis.Rilling@kerlabs.com
CC: dave@linux.vnet.ibm.com, arnd@arndb.de, jeremy@goop.org,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [RFC v2][PATCH 8/9] File descriprtors - dump state
References: <Pine.LNX.4.64.0808202251500.17436@takamine.ncl.cs.columbia.edu> <Pine.LNX.4.64.0808202306530.17436@takamine.ncl.cs.columbia.edu> <20080821110614.GK581@hawkmoon.kerlabs.com>
In-Reply-To: <20080821110614.GK581@hawkmoon.kerlabs.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Louis Rilling wrote:
> On Wed, Aug 20, 2008 at 11:07:16PM -0400, Oren Laadan wrote:
>> Dump the files_struct of a task with 'struct cr_hdr_files', followed by
>> all open file descriptors. Since FDs can be shared, they are assigned a
>> tag and registered in the object hash.
>>
>> For each open FD there is a 'struct cr_hdr_fd_ent' with the FD, its tag
>> and its close-on-exec property. If the FD is to be saved (first time)
>> then this is followed by a 'struct cr_hdr_fd_data' with the FD state.
>> Then will come the next FD and so on.
>>
>> This patch only handles basic FDs - regular files, directories and also
>> symbolic links.
> 
> [...]

[...]

> 
>> @@ -114,4 +125,24 @@ struct cr_hdr_vma {
>>
>>  } __attribute__ ((aligned (8)));
>>
>> +struct cr_hdr_files {
>> +	__u32 tag;	/* sharing identifier */
>> +	__u32 nfds;
>> +} __attribute__ ((aligned (8)));
>> +
>> +struct cr_hdr_fd_ent {
>> +	__u32 tag;
>> +	__u16 fd;
>> +	__u16 close_on_exec;
>> +} __attribute__ ((aligned (8)));
>> +
>> +struct cr_hdr_fd_data {
>> +	__u16 how;
>> +	__u16 f_mode;
>> +	__u32 f_flags;
>> +	__u32 f_uid, f_gid;
> 
> We are not at a 64bits boundary here. Should add one __32 padding or reorder the
> fields.

Actually this is ok - note there are two fields on fourth row. I'll
change to one field per row so it's easily seen.

Thanks,

Oren.

