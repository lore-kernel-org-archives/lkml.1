Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbYIHBty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbYIHBty (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 21:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbYIHBtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 21:49:47 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:17123 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbYIHBtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 21:49:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=s2Y9sI9ejIrNPMdsnadzHhar/8b75zQ2m+9JA1kJk9rqNtax1JLlnQ1JCv9i9w6mhR
         nrkUi1ZfiFKhMRihVdeqmpoc++0Rec0c1wGRyuFKdU3sOu9TtfzrthnZ+RyB9MxEwHMG
         XU4F0hkstbscCN3OawpBNsPIGdkrAPYfcr69E=
Date: Mon, 8 Sep 2008 09:49:40 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: David Dillow <dave@thedillows.org>
Cc: Yan Li <elliot.li.tech@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, joerg.roedel@amd.com, rjmaomao@gmail.com
Subject: Re: [PATCH 1/2] VMware detection support for x86 and x86-64
Message-ID: <20080908014939.GA11873@yantp.cn.ibm.com>
References: <20080221115452.GB13948@elte.hu> <20080907234510.GA24133@yantp.cn.ibm.com> <1220834216.1837.11.camel@obelisk.thedillows.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220834216.1837.11.camel@obelisk.thedillows.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 07, 2008 at 08:36:56PM -0400, David Dillow wrote:
> On Mon, 2008-09-08 at 07:45 +0800, Yan Li wrote:
> > +int is_vmware_guest(void)
> > +{
> > skipped....
> > +	/* Yes, we are running as VMware Guest */
> > +	printk(KERN_INFO "vmware detected\n");
> > +	return 1;
> > +}
> 
> If you want this to be used by more callsites, it probably doesn't make
> sense to have it print out a message each time.

Sure.  Another possible solution is to print that message at the first
call only, it's good for debugging to keep that in dmesg.

If it's not possible to do live migration in/out of a running VMware
environment, we can also safely do this detection only at the first
call to reduce overhead.

> In fact would it make more sense to have a framework (cpu feature flag?)
> to detect that we're in any virtualized environment and make this one of
> the detection routines, and perhaps cache the result. Especially if this
> detection would be used to manage anything near a hot-path in the page
> cache as you suggested.
> 
> But maybe that's overkill.

That sounds good too. And I think the current routines for detecting
KVM, Xen and VMWare are all ready. I can do that if there are more
positive feedbacks.

Thanks.

-- 
Li, Yan

"Everything that is really great and inspiring is created by the
individual who can labor in freedom."
              - Albert Einstein, in Out of My Later Years (1950)
