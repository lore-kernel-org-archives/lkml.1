Return-Path: <linux-kernel-owner+w=401wt.eu-S1755000AbYDEV2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbYDEV2U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 17:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbYDEV2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 17:28:09 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:64415 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbYDEV2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 17:28:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=mWJWu9VZPzN2dGeWD7U0vIDNZusZK9JBcZNbXt/m51Whc6aWWy/kARf5suWpQQk6RQ5X2rnCBkLkPcTkyUn1v6yXifehJiqF4da1pFdT3rKra16wjmOznTy2MNAAFYATMWL2wL/2PSD788eMFAqQfzTAY4cV3iIE1ZrZ1QtoNaQ=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology Karnataka
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [RFC][-mm] [1/2] Simple stats for cpu resource controller
Date: Sun, 6 Apr 2008 02:51:51 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: linux-kernel@vger.kernel.org, containers@lists.osdl.org, menage@google.com,
       a.p.zijlstra@chello.nl, balbir@in.ibm.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <200804052339.46632.balajirrao@gmail.com> <200804060201.52726.balajirrao@gmail.com> <20080405205914.GA25009@linux.vnet.ibm.com>
In-Reply-To: <20080405205914.GA25009@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804060251.51635.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 April 2008 02:29:14 am Dhaval Giani wrote:
> On Sun, Apr 06, 2008 at 02:01:52AM +0530, Balaji Rao wrote:
> > On Sunday 06 April 2008 01:10:41 am Dhaval Giani wrote:
> > > > +};
> > > > +
> > > > +struct cpu_cgroup_stat_cpu {
> > > > +	s64 count[CPU_CGROUP_STAT_NSTATS];
> > > 
> > > u64? time does not go negative :)
> > Right. But these stats are not only going to measure time. We need the 
same 
> > variables for measuring other stats as well. I'm not sure if we would 
> > encounter scheduler stats that would count negative.
> > 
> > Balbir, what do you say ?
> 
> I would prefer to keep the stats logically separate. So something like
> struct cpu_cgroup_stat_cpu {
> 	u64 time[];
> 	s64 some_other_stat;
> }
> and so on. (I am not sure, is there some advantage gained by using
> structs?) Makes the code more maintainable imho.
> 
This would break the generic nature of __cpu_cgroup_stat_add. Its not a nice 
thing in my opinion.

-- 
regards,
Balaji Rao
Dept. of Mechanical Engineering,
National Institute of Technology Karnataka, India
