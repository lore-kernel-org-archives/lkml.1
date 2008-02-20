Return-Path: <linux-kernel-owner+w=401wt.eu-S1758557AbYBTCvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557AbYBTCvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 21:51:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757651AbYBTCvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 21:51:41 -0500
Received: from smtp-out.google.com ([216.239.33.17]:10044 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757300AbYBTCvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 21:51:40 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=eMnvAf5QVTvPqpnkmY6IZjCPPKTiX0RHe1MkjT0SN7HZdXgrcWpCn4i2GosCYyyz/
	kqd7NfmWBixYkS48YDMbA==
Message-ID: <6599ad830802191851l66281e67rb49c766c2b1427c9@mail.gmail.com>
Date: Tue, 19 Feb 2008 18:51:29 -0800
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [RFC][PATCH 1/7] CGroup API: Add cgroup.api control file
Cc: "Li Zefan" <lizf@cn.fujitsu.com>, balbir@linux.vnet.ibm.com,
       balbir@in.ibm.com, xemul@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
       vatsa@linux.vnet.ibm.com, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080219155742.0298f25f.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080215204418.535025000@menage.corp.google.com>
	 <20080215204820.734926000@menage.corp.google.com>
	 <47B6B5CA.7040201@linux.vnet.ibm.com>
	 <6599ad830802160944v6d529570k1ade6df273ca3d0d@mail.gmail.com>
	 <47B953A8.9030206@cn.fujitsu.com> <20080219155742.0298f25f.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 19, 2008 1:57 PM, Paul Jackson <pj@sgi.com> wrote:
>
> Finally, it goes against the one thingie per file (at most, one scalar
> vector) that has worked well for us when tried.

Right, I like the idea of keeping things simple. But if you're going
to accept that a vector is useful, then it seems reasonable that some
other *simple* structured datatypes can be useful. An N-element
key/value map (a la /proc/meminfo) is, I think, nicer than having to
read values from N separate files.

>
> As to the motivations Paul M gives:
>  1) Avoid "an arbitrary mess of ad-hoc APIs":
>         We can still do that, whether or not we "self-document" these
>         API's in this manner.

We can, but this file makes it more clear what control files have a
well-defined API and which are just returning some ad-hoc string.

I guess it's not essential, I just figured that if we had that
information, it made sense to make it available to userspace. I guess
I'm happy with dropping the actual exposed cgroup.api file for now as
long as we can work towards reducing the number of control files that
just return strings, and make use of the structured output such as
read_uint() miore.

>  2) binary APIs versus ASCII APIs:
>         Well, I have an ASCII API bias, not surprising.  But I'd
>         suggest not doing things "in anticipation" of some future
>         fuzzy binary API support.  Wait until that day actually arrives.

I have a reasonably clear idea of how we can do the binary API.

That's mostly for a separate RFC. But for example, reading a map via
the binary API would be able to just return a list values since the
keys could be parsed once from the ascii map (provided that the
subsystem guaranteed that the map keys and their order wouldn't change
between reboots).


>  3) The memory controller currently has files with the "_in_bytes":
>         The traditional way to handle this is Documentation and man
>         pages; good enough for my granddad, good enough for me ;).

I've tried submitting patches to remove the in_bytes suffix and just
rely on the documentation, and people didn't seem to like it ...

Paul
