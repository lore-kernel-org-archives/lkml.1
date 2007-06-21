Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbXFUK30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbXFUK30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 06:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbXFUK3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 06:29:20 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:3654 "EHLO
	outbound8-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751936AbXFUK3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 06:29:19 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Thu, 21 Jun 2007 12:29:02 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "David Rientjes" <rientjes@google.com>
cc: "Stephane Eranian" <eranian@hpl.hp.com>,
       "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/8] 2.6.22-rc3 perfmon2 : Barcelona CPU detection
Message-ID: <20070621102901.GS24544@erda.amd.com>
References: <20070620182126.248753000@amd.com>
 <20070620184102.GB5874@erda.amd.com>
 <alpine.DEB.0.99.0706201244160.4562@chino.kir.corp.google.com>
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.0.99.0706201244160.4562@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 21 Jun 2007 10:29:02.0198 (UTC)
 FILETIME=[FC6DA160:01C7B3EE]
X-WSS-ID: 6A648D7B1S41022602-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.06.07 12:45:35, David Rientjes wrote:
> On Wed, 20 Jun 2007, Robert Richter wrote:
> 
> > Index: linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_k8.c
> > ===================================================================
> > --- linux-2.6.22-rc3.orig/arch/x86_64/perfmon/perfmon_k8.c
> > +++ linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_k8.c
> > @@ -307,7 +307,12 @@ static int pfm_k8_probe_pmu(void)
> >  		return -1;
> >  	}
> >  
> > -	if (current_cpu_data.x86 != 15) {
> > +	switch (current_cpu_data.x86) {
> > +	case 15:
> > +	case 16:
> > +		PFM_INFO("found family=%d", current_cpu_data.x86);
> > +		break;
> > +	default:
> >  		PFM_INFO("unsupported family=%d", current_cpu_data.x86);
> >  		return -1;
> >  	}
> 
> This still shouldn't be a switch clause because you're hiding the return 
> -1; in the default label.  I think it would be better to write:
> 
> 	if (current_cpu_data.x86 == 15 || current_cpu_data.x86 == 16)
> 		PFM_INFO("found family=%d", current_cpu_data.x86);
> 	else {
> 		PFM_INFO("unsupported family=%d", current_cpu_data.x86);
> 		return -1;
> 	}
> 
> 

With the next CPU family the if condition would be too long while
adding another case statement is more readable. Anyway, things always
have 2 sides and I understand your concerns.

-Robert


-- 
AMD Saxony, Dresden, Germany
Operating System Research Center
email: robert.richter@amd.com



