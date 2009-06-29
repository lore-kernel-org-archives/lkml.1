Return-Path: <linux-kernel-owner+w=401wt.eu-S1759351AbZF2WQC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351AbZF2WQC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 18:16:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbZF2WPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 18:15:54 -0400
Received: from claw.goop.org ([74.207.240.146]:52096 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbZF2WPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 18:15:53 -0400
Message-ID: <4A493D19.4050908@goop.org>
Date: Mon, 29 Jun 2009 15:15:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, npiggin@suse.de, chris.mason@oracle.com,
       kurt.hackel@oracle.com, dave.mccracken@oracle.com,
       Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
       alan@lxorguk.ukuu.org.uk, Rusty Russell <rusty@rustcorp.com.au>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, akpm@osdl.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, tmem-devel@oss.oracle.com,
       sunil.mushran@oracle.com, linux-mm@kvack.org,
       Himanshu Raj <rhim@microsoft.com>
Subject: Re: [RFC] transcendent memory for Linux
References: <a2cac9b3-74c1-4eea-8273-afe2226cef1d@default>
In-Reply-To: <a2cac9b3-74c1-4eea-8273-afe2226cef1d@default>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/09 14:57, Dan Magenheimer wrote:
> Interesting question.  But, more than the 128-bit UUID must
> be guessed... a valid 64-bit object id and a valid 32-bit
> page index must also be guessed (though most instances of
> the page index are small numbers so easy to guess).  Once
> 192 bits are guessed though, yes, the pages could be viewed
> and modified.  I suspect there are much more easily targeted
> security holes in most data centers than guessing 192 (or
> even 128) bits.
>   

If its possible to verify the uuid is valid before trying to find a
valid oid+page, then its much easier (since you can concentrate on the
uuid first).  If the uuid is derived from something like the
filesystem's uuid - which wouldn't normally be considered sensitive
information - then its not like its a search of the full 128-bit space. 
And even if it were secret, uuids are not generally 128 randomly chosen
bits.

You also have to consider the case of a domain which was once part of
the ocfs cluster, but now is not - it may still know the uuid, but not
be otherwise allowed to use the cluster.

> Now this only affects shared pools, and shared-precache is still
> experimental and not really part of this patchset.  Does "mount"
> of an accessible disk/filesystem have a better security model?
> Perhaps there are opportunities to leverage that?
>   

Well, a domain is allowed to access any block device you give it access
to.  I'm not sure what the equivalent model for tmem would be.

Anyway, it sounds like you need to think a fair bit more about shared
tmem's security model before it can be considered for use.

> Yes.  Perhaps all the non-flag bits should just be reserved for
> future use.  Today, the implementation just checks for (and implements)
> only zero anyway and nothing is defined anywhere except the 4K
> pagesize at the lowest levels of the (currently xen-only) API.
>   

Yes.  It should fail if it sees any unknown flags set in a guest request.

    J
