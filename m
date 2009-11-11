Return-Path: <linux-kernel-owner+w=401wt.eu-S1759691AbZKKXiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759691AbZKKXiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 18:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759676AbZKKXiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 18:38:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:28189 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759667AbZKKXiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 18:38:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,726,1249282800"; 
   d="scan'208";a="466508518"
Message-ID: <4AFB4AC7.1090405@intel.com>
Date: Wed, 11 Nov 2009 15:37:43 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081103)
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>
CC: Arjan van de Ven <arjan@infradead.org>, Jeff Garzik <jeff@garzik.org>,
       "Wu, Fengguang" <fengguang.wu@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, "mingo@elte.hu" <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] vfs: Add a trace point in the mark_inode_dirty function
References: <20091025225342.007138f5@infradead.org>	<20091111020108.GA11423@localhost>	<20091110223456.01ef355f@infradead.org> <4AFA6AEF.5060306@garzik.org>	<20091111081905.270a4e55@infradead.org> <y0m3a4kpsiw.fsf@fche.csb>
In-Reply-To: <y0m3a4kpsiw.fsf@fche.csb>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Ch. Eigler wrote:
> Arjan van de Ven <arjan@infradead.org> writes:
> 
>> [...]  ok let me rephrase that. What would a user DO with this inode
>> number information, given that the filename is already passed on;
>> what additional useful, not-infinitely-hard-to-get piece of
>> information [...]
> 
> Perhaps "infinitely hard" is the wrong criterion, but passing inode
> numbers lets a tracepoint client track changes to the same file, even
> though the file may be renamed/unlinked over time.

If you already know what the file object is, sure. We're interested in the case
where we have no clue what the file object actually is to begin with. Having a
trace with a random inode number pop up and then disappear into thin air won't
help much at all, especially if we can't map it back to something "real" on disk.
in time.

Auke

