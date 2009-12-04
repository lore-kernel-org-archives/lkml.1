Return-Path: <linux-kernel-owner+w=401wt.eu-S1757396AbZLDV3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbZLDV3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 16:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757310AbZLDV3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 16:29:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59116 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757307AbZLDV27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 16:28:59 -0500
Message-ID: <4B197ED3.9060003@zytor.com>
Date: Fri, 04 Dec 2009 13:27:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: "Cihula, Joseph" <joseph.cihula@intel.com>
CC: Andi Kleen <andi@firstfloor.org>, Pavel Machek <pavel@ucw.cz>,
       "Wang, Shane" <shane.wang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>
Subject: Re: [PATCH] intel_txt: add s3 userspace memory integrity	verification
References: <4A9CE0B2.5060608@intel.com> <4ABF2B50.6070106@intel.com> <20091004185801.GC1378@ucw.cz> <037F493892196B458CD3E193E8EBAD4F01F03277DF@pdsmsx502.ccr.corp.intel.com> <20091204081933.GE1540@ucw.cz> <4F65016F6CB04E49BFFA15D4F7B798D9AEDDD4C5@orsmsx506.amr.corp.intel.com> <20091204171333.GS18989@one.firstfloor.org> <4F65016F6CB04E49BFFA15D4F7B798D9AEDDD552@orsmsx506.amr.corp.intel.com> <20091204200933.GA741@basil.fritz.box> <4F65016F6CB04E49BFFA15D4F7B798D9AEDDD710@orsmsx506.amr.corp.intel.com>
In-Reply-To: <4F65016F6CB04E49BFFA15D4F7B798D9AEDDD710@orsmsx506.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2009 12:17 PM, Cihula, Joseph wrote:
> 
> I would expect that early_printk() coupled with tboot's serial output would be sufficient for a case such as this.  If we've done our work correctly, loss of integrity should only occur when the system is attacked across the S3 transition--which should be fairly rare and which should place a premium on prevention of the attacked code from executing.  Esp. on servers, there may not be anyone to see console output anyway.  Does early_printk() and a tboot reset seem like a reasonable approach?
> 

The zeroeth-order thing is you should reliably crash and reboot.  This
is pretty normal for most S3 resume failures anyway, so although it is
somewhat unfortunate for debugging, it is isn't exactly an unreasonable
thing to do.

Getting a message out is a nice plus, but not a requirement.
Guaranteeing the integrity is an absolute requirement.

	-hpa
