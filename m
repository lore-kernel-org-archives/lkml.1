Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbZJGDwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbZJGDwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 23:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbZJGDwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 23:52:07 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:27236
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753122AbZJGDwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 23:52:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAD+ty0p8qaJd/2dsb2JhbADUa4QqBIFTWA
X-IronPort-AV: E=Sophos;i="4.44,517,1249228800"; 
   d="scan'208";a="568915281"
Message-ID: <4ACC1023.4050906@themaw.net>
Date: Wed, 07 Oct 2009 11:50:59 +0800
From: Ian Kent <raven@themaw.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, autofs@linux.kernel.org,
       linux-fsdevel@vger.kernel.org, sage@newdream.net,
       viro@ZenIV.linux.org.uk, adilger@sun.com, hch@infradead.org,
       yehuda@newdream.net
Subject: Re: [PATCH 01/10] autofs4 - use macros for active list handling
References: <20091001010054.7675.77673.stgit@zeus.themaw.net> <20091006134918.4d5dcbaf.akpm@linux-foundation.org>
In-Reply-To: <20091006134918.4d5dcbaf.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 01 Oct 2009 09:00:55 +0800
> Ian Kent <raven@themaw.net> wrote:
> 
>> Define some simple macro functions for adding and deleting entries
>> on the active (and unhashed) dentry list.
> 
> A "macro" is that thing which we create with #define.

OK, guilty, ;)

> 
>> +static void autofs4_add_active(struct dentry *dentry)
>> +{
>> +	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
>> +	struct autofs_info *ino = autofs4_dentry_ino(dentry);
>> +	if (ino) {
>> +		spin_lock(&sbi->lookup_lock);
>> +		if (!ino->active_count) {
>> +			if (list_empty(&ino->active))
>> +				list_add(&ino->active, &sbi->active_list);
>> +		}
>> +		ino->active_count++;
>> +		spin_unlock(&sbi->lookup_lock);
>> +	}
>> +	return;
>> +}
>> +
>> +static void autofs4_del_active(struct dentry *dentry)
>> +{
>> +	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
>> +	struct autofs_info *ino = autofs4_dentry_ino(dentry);
>> +	if (ino) {
>> +		spin_lock(&sbi->lookup_lock);
>> +		ino->active_count--;
>> +		if (!ino->active_count) {
>> +			if (!list_empty(&ino->active))
>> +				list_del_init(&ino->active);
>> +		}
>> +		spin_unlock(&sbi->lookup_lock);
>> +	}
>> +	return;
>> +}
> 
> These aren't macros!  I changed the titles and changelogs of patches 1,
> 2 and 3 to use the term "helper functions".

Thanks, heaps.
Ian

