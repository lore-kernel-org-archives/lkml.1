Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbZAVG3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbZAVG3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 01:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755899AbZAVG3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 01:29:23 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:22313 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905AbZAVG3W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 01:29:22 -0500
MIME-Version: 1.0
In-Reply-To: <200901221142.00803.knikanth@suse.de>
References: <200901211638.23101.knikanth@suse.de>
	 <200901221043.13684.knikanth@suse.de>
	 <d6200be20901212139u3683c829x4db1840a28986a6f@mail.gmail.com>
	 <200901221142.00803.knikanth@suse.de>
Date: Wed, 21 Jan 2009 22:29:20 -0800
Message-ID: <d6200be20901212229y47353d3ft72fbfed6ffaba999@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, Chris Snook <csnook@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Paul Menage <menage@google.com>,
       containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 10:12 PM, Nikanth Karthikesan <knikanth@suse.de> wrote:
> On Thursday 22 January 2009 11:09:45 Arve Hjønnevåg wrote:
>> On Wed, Jan 21, 2009 at 9:13 PM, Nikanth Karthikesan <knikanth@suse.de>
> wrote:
>> > To use oom_adj effectively one should continuously monitor oom_score of
>> > all the processes, which is a complex moving target and keep on adjusting
>> > the oom_adj of many tasks which still cannot guarantee the order. This
>> > controller is deterministic and hence easier to use.
>>
>> Why not add an option to make oom_adj ensure strict ordering instead?
>
> This could be done in 2 ways.
> 1. Make oom_adj itself strict.(based on some other parameter?)
> - Adds to confusion whether the current oom_adj is a strict value or the usual
> suggestion.
> - It would disable the oom_adj suggestion which could have been used till now.
> - It is a public interface, and changing that might break some one's script.
>
> 2. Add addtional parameter, say  /proc/<pid>/oom_order
> - Not easy to use.
> - Say I had assigned the oom.victim to a task and it had forked a lot. Now to
> change the value for all the tasks it is easier with cgroups.
> - Some optimization that Kame specified earlier would be harder to achieve.
>

Both options would work for us, but option 1 require no change to our
user space code. I agree that some operations are easier with a
cgroups approach, but since we don't perform these operations it would
be nice to not require cgroups to control the oom killer.

-- 
Arve Hjønnevåg
