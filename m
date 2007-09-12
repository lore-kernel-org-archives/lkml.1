Return-Path: <linux-kernel-owner+w=401wt.eu-S967009AbXILLfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967009AbXILLfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 07:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764960AbXILLf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 07:35:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:35056 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766004AbXILLfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 07:35:25 -0400
Date: Wed, 12 Sep 2007 13:35:21 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: linux-arch@vger.kernel.org, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/5] Extended crashkernel command line
Message-ID: <20070912113521.GE26903@suse.de>
Mail-Followup-To: Vivek Goyal <vgoyal@in.ibm.com>,
	linux-arch@vger.kernel.org, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org
References: <20070909083914.065380136@strauss.suse.de> <20070909083914.488571169@strauss.suse.de> <20070911061522.GD5053@in.ibm.com> <20070911100110.GB31038@suse.de> <20070912112308.GA17436@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070912112308.GA17436@in.ibm.com>
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal <vgoyal@in.ibm.com> [2007-09-12 13:23]:
> On Tue, Sep 11, 2007 at 12:01:10PM +0200, Bernhard Walle wrote:
> > * Vivek Goyal <vgoyal@in.ibm.com> [2007-09-11 08:15]:
> > > 
> > > "offset" seems to be optional in the new syntax. What happens if user does
> > > not specify offset. I think crash_base will be set to zero and system will
> > > try to reserve x amount of memory start at zero? That would fail?
> > 
> > That's handled in the architecture specific code -- because it's
> > different on each architecture and the architecture specific code does
> > memory reservation. IA64 already can handle this case (on IA64,
> > specifying 0 is the same than leaving out the base address, and that's
> > why I wanted to keep that semantics). I think it doesn't also make
> > sense on i386/x86_64 to choose 0 as real base address, because the
> > value below 1 MB is special for booting ...
> > 
> 
> Ok. I see IA64 is handling this case. But in current patchset, i386 and
> x86_64 will try to reserve memory starting at zero?  So we still got
> to handle this case in i386 and x86_64?

Yes, my fault. I need to replace

+       if (ret == 0 && crash_size > 0) {

with

+       if (ret == 0 && crash_size > 0 && crash_base > 0) {

I'll repost the whole patch with all the corrections when I finished
PPC64 and SH. (I'm not in office this week, that's why I'm a bit slow.)


Thanks,
   Bernhard
