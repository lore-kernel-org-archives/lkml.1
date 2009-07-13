Return-Path: <linux-kernel-owner+w=401wt.eu-S1757123AbZGMUSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123AbZGMUSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 16:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757108AbZGMUSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 16:18:50 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:25038 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008AbZGMUSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 16:18:45 -0400
Date: Mon, 13 Jul 2009 16:17:45 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Avi Kivity <avi@redhat.com>, Dan Magenheimer <dan.magenheimer@oracle.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       npiggin@suse.de, akpm@osdl.org, jeremy@goop.org,
       xen-devel@lists.xensource.com, tmem-devel@oss.oracle.com,
       alan@lxorguk.ukuu.org.uk, linux-mm@kvack.org, kurt.hackel@oracle.com,
       Rusty Russell <rusty@rustcorp.com.au>, dave.mccracken@oracle.com,
       Marcelo Tosatti <mtosatti@redhat.com>, sunil.mushran@oracle.com,
       Schwidefsky <schwidefsky@de.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 0/4] (Take 2): transcendent memory ("tmem") for
	Linux
Message-ID: <20090713201745.GA3783@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Anthony Liguori <anthony@codemonkey.ws>,
	Avi Kivity <avi@redhat.com>,
	Dan Magenheimer <dan.magenheimer@oracle.com>,
	Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
	npiggin@suse.de, akpm@osdl.org, jeremy@goop.org,
	xen-devel@lists.xensource.com, tmem-devel@oss.oracle.com,
	alan@lxorguk.ukuu.org.uk, linux-mm@kvack.org,
	kurt.hackel@oracle.com, Rusty Russell <rusty@rustcorp.com.au>,
	dave.mccracken@oracle.com, Marcelo Tosatti <mtosatti@redhat.com>,
	sunil.mushran@oracle.com, Schwidefsky <schwidefsky@de.ibm.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>
References: <a09e4489-a755-46e7-a569-a0751e0fc39f@default> <4A5A1A51.2080301@redhat.com> <4A5A3AC1.5080800@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5A3AC1.5080800@codemonkey.ws>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Source-IP: abhmt005.oracle.com [141.146.116.14]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010201.4A5B966E.0191:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 12, 2009 at 02:34:25PM -0500, Anthony Liguori wrote:
> Avi Kivity wrote:
>>
>> In fact CMM2 is much more intrusive (but on the other hand provides  
>> much more information).
> I don't think this will remain true long term.  CMM2 touches a lot of  
> core mm code and certainly qualifies as intrusive.  However the result  
> is that the VMM has a tremendous amount of insight into how the guest is  
> using it's memory and can implement all sorts of fancy policy for  
> reclaim.  Since the reclaim policy can evolve without any additional  
> assistance from the guest, the guest doesn't have to change as policy  
> evolves.
>
> Since tmem requires that reclaim policy is implemented within the guest,  
> I think in the long term, tmem will have to touch a broad number of  
> places within Linux.  Beside the core mm, the first round of patches  
> already touch filesystems (just ext3 to start out with).  To truly be  
> effective, tmem would have to be a first class kernel citizen and I  
> suspect a lot of code would have to be aware of it.

This depends on the extent to which tmem is integrated into the VM.  For
filesystem usage, the hooks are relatively simple because we already
have a lot of code sharing in this area.  Basically tmem is concerned
with when we free a clean page and when the contents of a particular
offset in the file are no longer valid.

The nice part about tmem is that any time a given corner case gets
tricky, you can just invalidate that offset in tmem and move on.

-chris
