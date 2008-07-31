Return-Path: <linux-kernel-owner+w=401wt.eu-S1760013AbYGaWn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013AbYGaWn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 18:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759570AbYGaWnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 18:43:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:62414 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759499AbYGaWnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 18:43:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HxE8Nkd+2Yd7/AwVJX/8L3++S6nH52I5fzbmOyKZhuynb7fvoQaOocYG0pKH3ucHVl
         7+LXMWnvj6sKZFacgucU/F0LNbc65BQxQAHOjZqqfmPgLbBS8PZnjSkF9MPQBDs64E1B
         SEDS2cMNBmXZ+VAltuEynq9IYi3TVVg4tMjtM=
Date: Fri, 1 Aug 2008 00:42:22 +0200
From: Bernhard Fischer <rep.dot.nop@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com, Matt Mackall <mpm@selenic.com>,
       bcrl@kvack.org, linux-aio@kvack.org, akpm@linux-foundation.org
Subject: Re: [patch 1/4] Configure out AIO support
Message-ID: <20080731224222.GB9208@mx.loc>
References: <20080731092703.661994657@free-electrons.com> <20080731093220.690886851@free-electrons.com> <20080731100929.GA9206@mx.loc> <20080731101219.GC4221@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080731101219.GC4221@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 01:12:19PM +0300, Adrian Bunk wrote:
>On Thu, Jul 31, 2008 at 12:09:29PM +0200, Bernhard Fischer wrote:
>> On Thu, Jul 31, 2008 at 11:27:04AM +0200, Thomas Petazzoni wrote:
>> >This patchs adds the CONFIG_AIO option which allows to remove support
>> >for asynchronous I/O operations, that are not necessarly used by
>> >applications, particularly on embedded devices. As this is a
>> >size-reduction option, it depends on CONFIG_EMBEDDED. It allows to
>> >save ~7 kilobytes of kernel code/data:
>> 
>> Shouldn't this also make sure not to install aio_abi.h or at least an
>> empty aio_abi.h?
>
>The userspace headers are independent of any kernel configuration
>(except for the architecture).

I beg to disagree:
internals as exposed by e.g. aio_abi.h are impl dependent. Noone except
the impl and it's users are interrested in it.

If a per package feature, independent of arch, is off, all respective
features stuff should be off for that particular installation.

I.e. if I, for subsequent installations, choose to turn on feature, the
requested feature-stuff will be installed properly. If I, OTOH, choose
to (keep to) turn off feature, then all feature-related stuff should --
and has to be and stay -- turned off.

In the particular case of the kernel exposing unwanted API extensions
that are off, all such API reminiscences should be off, thus not
installed to my staging dir at all since i explicitely asked for doing
away with all of the API.

>From a libc POV i'd agree, but from an inherently broken userspace POV
installing willingly broken stuff is just wrong and misleading, imo.
