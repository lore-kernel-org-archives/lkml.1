Return-Path: <linux-kernel-owner+w=401wt.eu-S1753783AbYE3NGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbYE3NGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 09:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbYE3NGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 09:06:32 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:39309 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbYE3NGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 09:06:31 -0400
Subject: Re: [RFC][Patch 5/5]integrity: IMA as an integrity service provider
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com,
       Stephen Smalley <sds@tycho.nsa.gov>,
       CaseySchaufler <casey@schaufler-ca.com>
In-Reply-To: <20080528203013.5a927d30.akpm@linux-foundation.org>
References: <1211555145.16195.18.camel@new-host>
	 <20080528012242.a0e98d87.akpm@linux-foundation.org>
	 <1212031046.4747.57.camel@new-host.home>
	 <20080528203013.5a927d30.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 30 May 2008 09:06:09 -0400
Message-Id: <1212152769.21336.4.camel@new-host.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-28 at 20:30 -0700, Andrew Morton wrote:

> > > - ima_fixup_inodes looks like it will race and crash against a
> > >   well-timed unmount.  I expect you will need to bump s_count before
> > >   dropping sb_lock.  See writeback_inodes() for an example.
> > 
> > ima_fixup_inodes() is called once at initialization.  
> 
> What is "initialisation"?  During initcalls?  Are there even any files
> in cache at that time?  I bet we can arrange for the answer to become
> "no".

Yes, during the initcalls.  Is this possible even when using
late_initcall().  IMA is dependent on the TPM being available,
if it is being used.

Mimi



