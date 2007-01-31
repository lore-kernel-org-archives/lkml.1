Return-Path: <linux-kernel-owner+w=401wt.eu-S933302AbXAaOet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933302AbXAaOet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 09:34:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933303AbXAaOet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 09:34:49 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39859 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933302AbXAaOes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 09:34:48 -0500
Message-ID: <45C0A90B.5070808@us.ibm.com>
Date: Wed, 31 Jan 2007 08:34:51 -0600
From: "Steve French (smfltc)" <smfltc@us.ibm.com>
User-Agent: Mozilla Thunderbird 1.0 (Windows/20041206)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>, Mark Lord <lkml@rtr.ca>,
       Bron Gondwana <brong@fastmail.fm>, Mike Houston <mikeserv@bmts.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Daniel Drake <dsd@gentoo.org>, samba-technical@lists.samba.org,
       Vladimir Saveliev <vs@namesys.com>, reiserfs-dev@namesys.com,
       xfs-masters@oss.sgi.com
Subject: Re: How many people are using 2.6.16?
References: <45BE5948.6060403@redhat.com> <20070129160448.65fc63f3.mikeserv@bmts.com> <20070129221300.GC19422@brong.net> <20070130203933.GJ3754@stusta.de> <45BFF1F4.3060401@rtr.ca> <Pine.LNX.4.64.0701301748230.3611@woody.linux-foundation.org> <20070131070237.GT3754@stusta.de> <20070131114935.GP33919298@melbourne.sgi.com>
In-Reply-To: <20070131114935.GP33919298@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:

>On Wed, Jan 31, 2007 at 08:02:37AM +0100, Adrian Bunk wrote:
>  
>
>>On Tue, Jan 30, 2007 at 06:36:48PM -0800, Linus Torvalds wrote:
>>    
>>
>>>The issue was somewhat confused by people certainly *reporting* it for 
>>>older kernels. Also, as part of the dirty bit cleanups and sanity 
>>>checkingwe did actually seem to fix a long-standing CIFS corruption (and 
>>>apparently reisertfs/XFS problems too).
>>>
>>>But the *common* case was actually introduced with 2.6.19, and 2.6.16 
>>>wouldn't be affected. 
>>>      
>>>
>>Thanks for the clarifications.
>>
>>Regarding the longstanding CIFS/reiserfs/XFS problems, it seems the 
>>status is:
>>    
>>
>....
>  
>
>>XFS:
>>fix not yet in your tree
>>    
>>
>
>With the WARN_ON() in cancel_dirty_page() removed:
>
>http://git2.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ecdfc9787fe527491baefc22dce8b2dbd5b2908d
>
>XFS will behave exactly the same as 2.6.19 and previous releases.
>The patches I sent were only ever really workarounds to greatly
>reduce the race window that could lead to the warning being
>triggered.
>
>We really need Nick Piggin's invalidate/truncate/mmap race fixes to
>properly solve the XFS issues uncovered by Linus' changes. Given
>that we haven't had any reported cases of data corruption on XFS
>(and I couldn't trigger any even when seeing the warnings) I think
>we are fairly safe just maintaining the status quo and waiting the
>right fix to make it's way into the tree....
>
>Cheers,
>
>Dave.
>  
>
We did have one bug report of data corruption in cifs on older kernels 
copying large files which this resolves,
but 2.6.16 seems far enough to go back.
