Return-Path: <linux-kernel-owner+w=401wt.eu-S1751388Ab0ALBX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388Ab0ALBX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 20:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117Ab0ALBX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 20:23:27 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:55004 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab0ALBX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 20:23:26 -0500
To: Benjamin LaHaise <bcrl@lhnet.ca>
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 3/7] sysfs: Keep an nlink count on sysfs directories.
References: <m1d41g9z3q.fsf@fess.ebiederm.org>
	<1263241315-19499-3-git-send-email-ebiederm@xmission.com>
	<4B4BC683.7060508@kernel.org> <20100112005308.GL5524@kvack.org>
	<m1vdf82ksy.fsf@fess.ebiederm.org> <20100112011245.GM5524@kvack.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 11 Jan 2010 17:23:19 -0800
In-Reply-To: <20100112011245.GM5524@kvack.org> (Benjamin LaHaise's message of "Mon\, 11 Jan 2010 20\:12\:45 -0500")
Message-ID: <m1hbqs2k1k.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin LaHaise <bcrl@lhnet.ca> writes:

> On Mon, Jan 11, 2010 at 05:06:53PM -0800, Eric W. Biederman wrote:
>> I don't see the link count as interesting enough to store more than
>> 16bits for it.  Even with 32bits of storage for nlink sysfs would have
>> to have to handle the rollover case as I am doing now.  So I don't
>> see any advantage to storing more bits.
>
> I'm not terribly concerned with what value gets returned, but rather about 
> how long is spent calculating it.  Ideally, new sysfs directory entries 
> can be inserted in an O(1) or other reasonable order operation.  I'll try 
> to find some time to re-run my interface scaling tests with your latest 
> changes.

Sounds good.  My changes so far have been the easy low hanging fruit.

readdir should be at O(N) and stat etc should all be constant time.
Lookups by name are still O(N), and I'm not ready to look at going
better until after I have network namespace support into sysfs.

Eric


