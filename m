Return-Path: <linux-kernel-owner+w=401wt.eu-S934290AbZKXWlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934290AbZKXWlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 17:41:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934105AbZKXWlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 17:41:42 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:41713 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933988AbZKXWll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 17:41:41 -0500
Message-ID: <4B0C60A1.6030509@nortel.com>
Date: Tue, 24 Nov 2009 16:39:29 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Eyal Lotem <eyal.lotem@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Using "page credits" as a solution for common thrashing
  scenarios
References: <b64f365b0911171252q42a0c102jddb2cd29af64a7a7@mail.gmail.com> <87aaybwrny.fsf@basil.nowhere.org>
In-Reply-To: <87aaybwrny.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Nov 2009 22:41:35.0303 (UTC) FILETIME=[46ED7570:01CA6D57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2009 03:15 PM, Andi Kleen wrote:
> Eyal Lotem <eyal.lotem@gmail.com> writes:
> 
> Replying to an old email.
> 
>>   * I think it is wrong for the kernel to evict the 15 pages of the bash,
>>     xterm, X server's working set, as an example, in order for a
>>     misbehaving process to have 1000015 instead of 1000000 pages in its
>>     working set. EVEN if that misbehaving process is accessing its working
>>     set far more aggressively.
> 
> One problem in practice tends to be that it's hard to realiably detect
> that a process is misbehaving. The 1000000 page process might be your
> critical database, while the 15 page process is something very
> unimportant.

Quite a while ago now I proposed the ability for an app (with suitable
privileges) to register with the system the amount of memory it expected
to use.  As long as it was under that amount it would be immune to the
oom-killer.

We've been using this in production for some time now as we have several
very large memory footprint apps that otherwise become quite attractive
to the oom killer.

The oom_adj proc entry made this less of an issue so I never bothered
pushing it to mainline.

Chris
