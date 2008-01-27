Return-Path: <linux-kernel-owner+w=401wt.eu-S1756282AbYA0KF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbYA0KF1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 05:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbYA0KFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 05:05:19 -0500
Received: from 8bytes.org ([88.198.83.132]:47834 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbYA0KFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 05:05:18 -0500
Date: Sun, 27 Jan 2008 11:05:17 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 8/8] SVM: add support for Nested Paging
Message-ID: <20080127100517.GC32677@8bytes.org>
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com> <1201294393-22613-9-git-send-email-joerg.roedel@amd.com> <479C464E.2060009@qumranet.com> <20080127094147.GA32677@8bytes.org> <479C540A.8020003@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479C540A.8020003@qumranet.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2008 at 11:51:06AM +0200, Avi Kivity wrote:
> Joerg Roedel wrote:
> >
> >> What happens to lazy fpu if we don't trap cr0 changes?
> >>
> >> Perhaps it's worth disabling lazy fpu with npt.
> >>     
> >
> > It should be implicitly disabled with npt because accesses to cr3 are
> > not intercepted anymore. The svm_set_cr3 function is the only place
> > which disables fpu switching.
> >   
> 
> Okay.  We may want to investigate enabling it later, but no hurry now.
> 
> On the other hand, we want to trap cr0 so the guest can't control the 
> cache disable bits.  Also cr4.pce and cr4.mce.

Is it a problem when the guest disables caching? It disables it only in
its own context because it has its own copy of cr0. Cr4.pce can be
accessible for the guests because there is no way for them to access the
performance counter MSRs. But I am not sure about MCE, I will check
that.
