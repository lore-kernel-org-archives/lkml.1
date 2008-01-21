Return-Path: <linux-kernel-owner+w=401wt.eu-S1757945AbYAUGGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbYAUGGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 01:06:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbYAUGFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 01:05:55 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:31008 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbYAUGFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 01:05:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ekl3ey2Wpado3PkPXwuI4jsUZEATZvSyr9F2iDMgPMCFqJdpnLVA2RdUL46BI2EoHrzsNUmKbgVGUHBSTJDNqt1LP3SSZMRq6/Gl9xLvF5/xcz+KU250hQErkc+ErWA4EIUyHNZllef71yzndWHIP3imrseQjiRPlt0W4EJimEU=
Subject: Re: [PATCH] x86_64: update e820 instead of updating end_pfn v2
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andi Kleen <ak@suse.de>
Cc: Yinghai Lu <Yinghai.Lu@sun.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200801210658.04030.ak@suse.de>
References: <200801192045.17291.yinghai.lu@sun.com>
	 <200801201608.15401.ak@suse.de> <200801202140.57829.yinghai.lu@sun.com>
	 <200801210658.04030.ak@suse.de>
Content-Type: text/plain
Date: Sun, 20 Jan 2008 22:05:58 -0800
Message-Id: <1200895558.5724.235.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-01-21 at 06:58 +0100, Andi Kleen wrote:
> >  {
> >  	u32 l, h;
> >  
> > @@ -661,8 +661,9 @@ static __init int amd_special_default_mt
> >  	 * Memory between 4GB and top of mem is forced WB by this magic bit.
> >  	 * Reserved before K8RevF, but should be zero there.
> >  	 */
> > -	if (l & Tom2ForceMemTypeWB)
> > -		return 1;
> > +	if (l & Tom2Enabled)
> > +		if (l & Tom2ForceMemTypeWB)
> > +			return 1;
> 
> That change is good agreed, but I would suggest to put it into a separate
> patch with a description
> 

Perhaps like this:

if (l & (Tom2Enabled|Tom2ForceMemTypeWB))
	return 1;

Harvey

