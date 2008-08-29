Return-Path: <linux-kernel-owner+w=401wt.eu-S1757724AbYH2AdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724AbYH2AdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 20:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbYH2AdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 20:33:00 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:42836 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753194AbYH2Ac7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 20:32:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=y13lHWZPSzHL3SqpP/fNxI3++Ntx5LxJvf0n/+ZOZDC3X8vFN4RFEoPisGKx06+qQ5QuycyensNXUTDhfysSx+hn5P26/EHbZbXj1CI0m0SVK/L4AYDLvvtREuOHuzCOGU2T4Hz1VAEBQqJmbjZj2B24Y/+bTzDlPR4QQ4rCsv8=  ;
X-YMail-OSG: Cn.iWqEVM1l0VJl6uduMYok5gMxsyGlNawyvpeqaUn5sj4uA8BT5YY277TaSkgOvGfvSMrYFiA0hYhsZorZUznDQzXOLkIJmVPY8DQ7NspHQ9NGREdBdGRlDudLMJVDmQs1pkqMhrjb757hpQj6CVqAa
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2.6.27-rc4] rtc-cmos: wakes again from S5
Date: Thu, 28 Aug 2008 17:32:57 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Stefan.Becker@nokia.com, rjw@sisk.pl
References: <200808281129.35611.david-b@pacbell.net> <20080828172206.5e083817.akpm@linux-foundation.org>
In-Reply-To: <20080828172206.5e083817.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808281732.57394.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 August 2008, Andrew Morton wrote:
> On Thu, 28 Aug 2008 11:29:35 -0700
> David Brownell <david-b@pacbell.net> wrote:
> 
> > +	if (system_state == SYSTEM_POWER_OFF && !cmos_poweroff(pdev))
> 
> erp, system_state is a pretty horrid thing.  It's a global with
> relatively poorly defined transition conditions which have actually
> changed over time.

True, but it's the best we've got for this kind of thing.
Globals ... yeech.


> It was not my greatest ever idea.  It was simple and expedient at the
> time and expanded use of it was "discouraged" (rofl).
> 
> Is there no alternative?

My general belief is that there should be a set of predicates
that drivers use to test whether or not the target system state
satisfies various prerequisites.  Like whether a clock or power
domain must be disabled, and so on.

In this specific case, a system_is_powering_down() predicate is
the logical application of that policy to this problem.

- Dave



