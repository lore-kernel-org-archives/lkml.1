Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbZA2RgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbZA2RgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 12:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbZA2RgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 12:36:04 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:63960 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbZA2RgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 12:36:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Ra6FZPGkZvpKNHhAeO6jzOf4KOBFvUCVeCy+zk3QCY9wrqZDrGXmiY+IcFSWRPd1lu
         oO1PBV8vutAbkCw1y0tHB0e8wLuQafz3I+H6NLcbvy75r6pR+x1CG/psGQvyYYFTKfq1
         ZNF3VkD0e53bedh155/Kj05D9HYPddIiZndCU=
MIME-Version: 1.0
In-Reply-To: <4981D957.8040409@ti.com>
References: <CF7665F795A4BE438425FE728CEACFA302F2436B52@dlee01.ent.ti.com>
	 <20090114221624.76ee8aa4.akpm@linux-foundation.org>
	 <7B4574D56E4ADF438756313E9A172A872CB8232E@dlee01.ent.ti.com>
	 <7E82351C108FA840AB1866AC776AEC46471B9452@orsmsx505.amr.corp.intel.com>
	 <7B4574D56E4ADF438756313E9A172A872CB82749@dlee01.ent.ti.com>
	 <1233081369.28350.68.camel@jamoon.sc.intel.com>
	 <7E82351C108FA840AB1866AC776AEC464723835C@orsmsx505.amr.corp.intel.com>
	 <4981D957.8040409@ti.com>
Date: Thu, 29 Jan 2009 09:36:00 -0800
X-Google-Sender-Auth: db353fe3fced90bb
Message-ID: <1f1b08da0901290936k71d016fcme81f04ca16029a7c@mail.gmail.com>
Subject: Re: [RFC] Dynamic Tick and Deferrable Timer Support
From: john stultz <johnstul@us.ibm.com>
To: Jon Hunter <jon-hunter@ti.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 8:29 AM, Jon Hunter <jon-hunter@ti.com> wrote:
> Pallipadi, Venkatesh wrote:
> I have spent several weeks trying to suppress kernel timers using the
> deferred timers and lengthen the sleep time. I am now able to get the device
> to sleep for minutes but I found that max_delta_ns is a limiting factor. I
> will be surprised if you can sleep for longer than ~2.15 seconds with the
> current implementation.

As an aside, there are some further hardware limitations in the
timekeeping core that limit the amount of time the hardware can sleep.
For instance, the acpi_pm clocksource wraps every 2.5 seconds or so,
so we have to wake up periodically to sample it to avoid wrapping
issues.

Just to be able to deal with all the different hardware out there, the
timekeeping core expects to wake up twice a second to do this
sampling. It may be possible to push this out if you are using other
clocksources (HPET/TSC), but if sleeps for longer then a second are a
needed feature, we probably will need some infrastructure in the
timekeeping core that can be queried to make sure its safe.

thanks
-john
