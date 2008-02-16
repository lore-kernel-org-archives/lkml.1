Return-Path: <linux-kernel-owner+w=401wt.eu-S1759750AbYBPSbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759750AbYBPSbr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 13:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbYBPSbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 13:31:37 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:64446 "EHLO
	outbound7-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752940AbYBPSbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 13:31:35 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <47B72BFE.9060302@am.sony.com>
Date: Sat, 16 Feb 2008 10:31:26 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Willy Tarreau <w@1wt.eu>, Roel Kluin <12o3l@tiscali.nl>,
       linuxppc-dev@ozlabs.org, cbe-oss-dev@ozlabs.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Fix Unlikely(x) == y
References: <47B70A61.9030306@tiscali.nl>	<20080216092552.325e5726@laptopd505.fenrus.org>	<20080216173315.GU8953@1wt.eu> <20080216094226.1e8eede1@laptopd505.fenrus.org>
In-Reply-To: <20080216094226.1e8eede1@laptopd505.fenrus.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Feb 2008 18:31:31.0352 (UTC) FILETIME=[269BF980:01C870CA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2008 09:42 AM, Arjan van de Ven wrote:
> On Sat, 16 Feb 2008 18:33:16 +0100
> Willy Tarreau <w@1wt.eu> wrote:
> 
>> On Sat, Feb 16, 2008 at 09:25:52AM -0800, Arjan van de Ven wrote:
>> > On Sat, 16 Feb 2008 17:08:01 +0100
>> > Roel Kluin <12o3l@tiscali.nl> wrote:
>> > 
>> > > The patch below was not yet tested. If it's correct as it is,
>> > > please comment. ---
>> > > Fix Unlikely(x) == y
>> > > 
>> > 
>> > you found a great set of bugs..
>> > but to be honest... I suspect it's just best to remove unlikely
>> > altogether for these cases; unlikely() is almost a
>> > go-faster-stripes thing, and if you don't know how to use it you
>> > shouldn't be using it... so just removing it for all wrong cases is
>> > actually the best thing to do imo.
>> 
>> Well, eventhough the author may not know how to use it, "unlikely" at
>> least indicates the intention of the author, or his knowledge of what
>> should happen here. I'd suggest leaving it where it is because the
>> authot of this code is in best position to know that this branch is
>> unlikely to happen, eventhough he does not correctly use the macro.
>>
> 
> you have more faith in the authors knowledge of how his code actually behaves than I think is warranted  :)
> Or faith in that he knows what "unlikely" means.
> I should write docs about this; but unlikely() means:
> 1) It happens less than 0.01% of the cases.
> 2) The compiler couldn't have figured this out by itself
>    (NULL pointer checks are compiler done already, same for some other conditions)
> 3) It's a hot codepath where shaving 0.5 cycles (less even on x86) matters
>    (and the author is ok with taking a 500 cycles hit if he's wrong)
> 
> If you think unlikely() means something else, we should fix what it maps to towards gcc ;)
> (to.. be empty ;)

Well, I didn't consider what today's compiler does, but used it as a general
indicator, because I think that code will be around a long time.  If you show
me some test results that prove it causes harm I might consider removing it. 

-Geoff


