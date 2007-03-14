Return-Path: <linux-kernel-owner+w=401wt.eu-S1030683AbXCNHKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030683AbXCNHKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 03:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030690AbXCNHKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 03:10:20 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:22026 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030683AbXCNHKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 03:10:20 -0400
Message-ID: <45F7A04B.6000504@sw.ru>
Date: Wed, 14 Mar 2007 10:12:11 +0300
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: vatsa@in.ibm.com
CC: Herbert Poetzl <herbert@13thfloor.at>,
       "Eric W. Biederman" <ebiederm@xmission.com>, containers@lists.osdl.org,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/7] Resource counters
References: <45ED7DEC.7010403@sw.ru> <45ED7F69.60108@sw.ru> <45EE39A5.7010804@in.ibm.com> <45EE6769.9060701@sw.ru> <20070309163711.GA3647@MAIL.13thfloor.at> <m1fy8bwqps.fsf@ebiederm.dsl.xmission.com> <20070312011612.GD21861@MAIL.13thfloor.at> <m1bqixtsr1.fsf@ebiederm.dsl.xmission.com> <20070313152150.GK8755@MAIL.13thfloor.at> <45F6C611.7070400@sw.ru> <20070313160707.GF19939@in.ibm.com>
In-Reply-To: <20070313160707.GF19939@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Srivatsa Vaddagiri wrote:
> On Tue, Mar 13, 2007 at 06:41:05PM +0300, Pavel Emelianov wrote:
>>> right, but atomic ops have much less impact on most
>>> architectures than locks :)
>> Right. But atomic_add_unless() is slower as it is
>> essentially a loop. See my previous letter in this sub-thread.
> 
> If I am not mistaken, you shouldn't loop in normal cases, which means
> it boils down to a atomic_read() + atomic_cmpxch()
> 
> 

So does the lock - in a normal case (when it's not
heavily contented) it will boil down to atomic_dec_and_test().

Nevertheless, making charge like in this patchset
requires two atomic ops with atomic_xxx and only
one with spin_lock().
