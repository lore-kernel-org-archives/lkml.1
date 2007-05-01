Return-Path: <linux-kernel-owner+w=401wt.eu-S1946033AbXEAWIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946033AbXEAWIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 18:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946032AbXEAWIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 18:08:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:13019 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946033AbXEAWIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 18:08:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,475,1170662400"; 
   d="scan'208";a="237537598"
Message-ID: <4637BA70.8000108@intel.com>
Date: Tue, 01 May 2007 15:08:48 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Michel Lespinasse <walken@zoy.org>
CC: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>, Jeb Cramer <cramerj@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: 24 lost ticks with 2.6.20.10 kernel
References: <20070501130715.GB29131@zoy.org> <46375E04.5030506@redhat.com> <20070501214912.GA4048@zoy.org>
In-Reply-To: <20070501214912.GA4048@zoy.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 May 2007 22:08:49.0555 (UTC) FILETIME=[4BC69E30:01C78C3D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse wrote:
> (I've added the E1000 maintainers to the thread as I found the issue
> seems to go away after I compile out that driver. For reference, I was
> trying to figure out why I lose exactly 24 ticks about every two
> seconds, as shown with report_lost_ticks. This is with a DQ965GF
> motherboard with onboard E1000).

that's perfectly likely. The main issue is that we read the hardware stats every 
two seconds and that can consume quite some time. It's strange that you are 
losing that many ticks IMHO, but losing one or two might very well be.

We've been playing with all sorts of solutions to this problem and haven't come 
up with a way to reduce the load of the system reading HW stats, and it remains 
the most likely culprit, allthough I don't rule out clean routines just yet. 
This could very well be exaggerated at 100mbit speeds as well, I never looked at 
that.

I've had good results with 2.6.21.1 (even running tickless :)) on these NICs. 
Have you tried that yet?

Auke
