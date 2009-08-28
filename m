Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbZH1Uvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbZH1Uvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 16:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbZH1Uvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 16:51:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195AbZH1Uvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 16:51:35 -0400
Message-ID: <4A984337.7080009@redhat.com>
Date: Fri, 28 Aug 2009 13:51:03 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Jamie Lokier <jamie@shareable.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: adding proper O_SYNC/O_DSYNC, was Re: O_DIRECT and barriers
References: <20090821174525.GA28861@infradead.org> <20090822005006.GA22530@shareable.org> <20090824023422.GA775@infradead.org> <20090827143459.GB31453@shareable.org> <20090827171044.GA5427@infradead.org> <4A96C14C.8040105@redhat.com> <20090828154647.GA15808@infradead.org> <4A98008B.6050503@redhat.com> <20090828161745.GA8755@infradead.org> <4A9806D9.5050409@redhat.com> <20090828164106.GA9951@infradead.org>
In-Reply-To: <20090828164106.GA9951@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2009 09:41 AM, Christoph Hellwig wrote:
> Yeah.  The implementation really is trivial in 2.6.32 - we basically
> just need to change one function to check the new O_REALLY_SYNC flag
> and pass down a 0 instead of a 1 to another routine in the generic
> fs code, plus doing the same in a few filesystems opencoding it instead
> of using the generic helpers.

I don't think you have to change anything.  As I wrote before, the 
kernel ignores unknown O_* flags.  It's usually a problem.  Here it is a 
positive thing.


> So the logistics of doing the flags really is the biggest work here.
> And I'm not entirely sure how to do it correctly.  Can we just switch
> the current O_SYNC defintion in the kernel headers to O_DSYNC while
> adding the new O_SYNC and everything will continue to work?

No, that's not a good idea.  This would mean a program compiled with 
newer headers is using O_SYNC which isn't known to old kernels and 
ignored.  Such programs will then not even get the current O_DSYNC benefits.


> That includes a write from another process?  So O_RSYNC basically means
> doing an range-fdatasync before the actual read request?

Yes.  You can easily see how this can be useful.


> Again, we could implement this easily if we care enough.

I think it can be useful at times.

-- 
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
