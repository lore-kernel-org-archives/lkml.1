Return-Path: <linux-kernel-owner+w=401wt.eu-S932409AbZLDRya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbZLDRya (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 12:54:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932304AbZLDRy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 12:54:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39563 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295AbZLDRy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 12:54:28 -0500
Message-ID: <4B194CA1.3070106@zytor.com>
Date: Fri, 04 Dec 2009 09:53:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "Cihula, Joseph" <joseph.cihula@intel.com>, Pavel Machek <pavel@ucw.cz>,
       "Wang, Shane" <shane.wang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>
Subject: Re: [PATCH] intel_txt: add s3 userspace memory integrity verification
References: <4A9CE0B2.5060608@intel.com> <4ABF2B50.6070106@intel.com> <20091004185801.GC1378@ucw.cz> <037F493892196B458CD3E193E8EBAD4F01F03277DF@pdsmsx502.ccr.corp.intel.com> <20091204081933.GE1540@ucw.cz> <4F65016F6CB04E49BFFA15D4F7B798D9AEDDD4C5@orsmsx506.amr.corp.intel.com> <20091204171333.GS18989@one.firstfloor.org>
In-Reply-To: <20091204171333.GS18989@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2009 09:13 AM, Andi Kleen wrote:
>>>
>>> So no, you did not audit do_suspend_lowlevel to make sure it does not
>>> follow function pointers. Bad.
>>
>> We aren't aware of any code or data used by the resume path that is outside of the tboot-MAC'ed regions above--if you can point out any then we will gladly address them.
> 
> Code coverage is not enough, you need data coverage too.  If someone 
> modifies kernel data it's typically easy to subvert code as a next step.
> 

The only function pointers that are invoked on the do_suspend_lowlevel
path are some paravirt_crap pointers, but those are located inside
kernel static data.

This is not to say that this isn't a new constraint, and should be
documented, and checked ahead of time...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

