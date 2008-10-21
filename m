Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbYJUNWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbYJUNWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 09:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbYJUNWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 09:22:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47865 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbYJUNW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 09:22:29 -0400
Subject: Re: [PATCH 1/4] CAPABILITIES: add cpu endian vfs caps structure
From: Eric Paris <eparis@redhat.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com,
       viro@zeniv.linux.org.ok, sgrubb@redhat.com, serue@us.ibm.com
In-Reply-To: <48FD6DA1.5030402@kernel.org>
References: <20081020222538.3895.50175.stgit@paris.rdu.redhat.com>
	 <20081020222602.3895.77302.stgit@paris.rdu.redhat.com>
	 <48FD6DA1.5030402@kernel.org>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 09:22:17 -0400
Message-Id: <1224595337.3189.196.camel@paris-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-20 at 22:50 -0700, Andrew G. Morgan wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Eric Paris wrote:
> > This patch add a generic cpu endian caps structure and enternally available
> > functions which retrieve fcaps information from disk.  This information is
> > necessary so fcaps information can be collected and recorded by the audit
> > system.
> > 
> [...]
> >  	CAP_FOR_EACH_U32(i) {
> > -		__u32 value_cpu;
> > -
> > -		if (i >= tocopy) {
> > -			/*
> > -			 * Legacy capability sets have no upper bits
> > -			 */
> > -			bprm->cap_post_exec_permitted.cap[i] = 0;
> > +		if (i > tocopy) {
> 
> Shouldn't the above still be (i >= tocopy) ?

just replaced this with

if (i >= tocopy)
        break;

I'm already zero'ing out the cap data at the beginning so there isn't
really a need for me to zero the upper bits if they aren't set.

-Eric

