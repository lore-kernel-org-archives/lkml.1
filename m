Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbZANCsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbZANCsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 21:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbZANCsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 21:48:30 -0500
Received: from mga10.intel.com ([192.55.52.92]:9672 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751393AbZANCs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 21:48:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,261,1231142400"; 
   d="scan'208";a="656923685"
Message-ID: <496D526D.1010402@linux.intel.com>
Date: Wed, 14 Jan 2009 02:48:13 +0000
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: kernel BUG at fs/ext/super.c:428
References: <20090110003645.GA16107@linux-os.sc.intel.com> <20090113164842.c6aa7095.akpm@linux-foundation.org> <20090114014434.GE14730@mit.edu>
In-Reply-To: <20090114014434.GE14730@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Tue, Jan 13, 2009 at 04:48:42PM -0800, Andrew Morton wrote:
>> Well that's not good.  I don't recall us making any changes which
>> affect the orphan list handling.  Perhaps "filesystem freeze: add error
>> handling of write_super_lockfs/unlockfs", but only indirectly.
>>
>> Does Arjan's new async stuff play with filesystems at umount/shutdown
>> time?  Don't think so.
> 
> Well, Arjan's commit, efaee192: "async: make the final inode deletion
> an asynchronous event", does change how inodes get deleted, and this
> looks like a race where an inode is getting deleted during the umount.
> 
> So I would try reverting commit efaee192 and see if it fixes things
> before starting a full bisect...

the commit is already reverted before rc1

