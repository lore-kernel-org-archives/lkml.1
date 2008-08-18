Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839AbYHRRjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbYHRRjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 13:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbYHRRjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 13:39:12 -0400
Received: from mail.lang.hm ([64.81.33.126]:55207 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbYHRRjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 13:39:12 -0400
Date: Mon, 18 Aug 2008 10:38:54 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Eric Paris <eparis@redhat.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, tvrtko.ursulin@sophos.com,
       Theodore Tso <tytso@mit.edu>, davecb@sun.com,
       Adrian Bunk <bunk@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       malware-list@lists.printk.net, Casey Schaufler <casey@schaufler-ca.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] scanner interface proposal was: [TALPA]	Intro	to
 a linux interface for on access scanning
In-Reply-To: <1219080504.15566.65.camel@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0808181033290.15109@asgard.lang.hm>
References: <20080818153212.6A6FD33687F@pmx1.sophos.com>  <1219076143.15566.39.camel@localhost.localdomain>  <20080818171500.78590801@lxorguk.ukuu.org.uk> <1219080504.15566.65.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008, Eric Paris wrote:

> On Mon, 2008-08-18 at 17:15 +0100, Alan Cox wrote:
>>> read -> we have the ALLOW/mark result bit in core set so just allow.
>>
>> Don't think we need this - SELinux can do that bit
>>
>>> mtime update -> clear ALLOW/"mark result" bit in core, send async
>>> notification to userspace
>>
>> Why via the kernel ?
>
> the single in core allow/deny bit is so that the vast majority of
> operations are completely free.  Say we scan/index /lib/ld-linux.so.2
> once.  Do you really want every single read/mmap operation from then on
> to have to block waiting for the userspace caches of you HSM, your AV
> scanner, and you indexer?  If all three tell the kernel they don't need
> to see it again and that information is easy and free to maintain, lets
> do it.

this is why the proposal caches the results of all the scanners with the 
file (in the xattrs), rather then having each scanner store it's own scan 
results

David Lang
