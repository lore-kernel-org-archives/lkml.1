Return-Path: <linux-kernel-owner+w=401wt.eu-S1758249AbYAJJoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249AbYAJJoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 04:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbYAJJoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 04:44:05 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:53740 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbYAJJoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 04:44:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QXBYxCchtEkBU7cyu6teyOL/iemzcvsTFe8+JZEaN7vxKrtMSNBXl/1bbjnCjvvJjyKEawl5DCvnCbBI4EnmM0OFNFj4mQ0Pa62jlWZbfblmyD8+aoIT9/oZvanKEXv9ng1gc75znhUjvMoryRohCIo0eaWhjkn4qmXsKxU019A=
Message-ID: <21d7e9970801100144x63b02e1bga548acd3c5bed441@mail.gmail.com>
Date: Thu, 10 Jan 2008 19:44:03 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: CPA patchset
Cc: "Andi Kleen" <ak@suse.de>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Venki Pallipadi" <venkatesh.pallipadi@intel.com>,
       suresh.b.siddha@intel.com, "Arjan van de Ven" <arjan@infradead.org>,
       "Dave Jones" <davej@redhat.com>
In-Reply-To: <20080110093126.GA360@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080103424.989432000@suse.de> <20080110093126.GA360@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> finally managed to get the time to review your CPA patchset, and i
> fundamentally agree with most of the detail changes done in it. But here
> are a few structural high-level observations:
>
> - firstly, there's no rationale given. So we'll change ioremap()/etc.
>   from doing a cflush-range instruction instead of a WBINVD. But why?
>   WBINVD isnt particular fast (takes a few msecs), but why is that a
>   problem? Drivers dont do high-frequency ioremap-ing. It's typically
>   only done at driver/device startup and that's it. Whether module load
>   time takes 1254 msecs instead of 1250 msecs is no big deal.

read graphics drivers, even though I think we may avoid the whole path
if we can and end up doing some of this in the drivers
when they know more about the situation so can avoid safeties..

but I still see this being used in AGP a fair bit at some point on
some drivers..

Dave.
