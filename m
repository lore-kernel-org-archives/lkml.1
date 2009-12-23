Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbZLWPMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbZLWPMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 10:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbZLWPMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 10:12:32 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:63134 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbZLWPMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 10:12:30 -0500
Message-ID: <4B323353.8000607@codemonkey.ws>
Date: Wed, 23 Dec 2009 09:12:19 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Andi Kleen <andi@firstfloor.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B2FA655.6030205@gmail.com> <4B2FAE7B.9030005@codemonkey.ws> <4B2FB3F1.5080808@gmail.com> <4B300EF8.8010602@codemonkey.ws> <87637zdy9g.fsf@basil.nowhere.org> <4B30E654.40702@codemonkey.ws> <20091222162110.GG10314@basil.fritz.box> <4B30F375.6050103@codemonkey.ws> <20091222173326.GH10314@basil.fritz.box> <4B3136AA.50204@codemonkey.ws> <20091223000210.GA6518@sequoia.sous-sol.org>
In-Reply-To: <20091223000210.GA6518@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2009 06:02 PM, Chris Wright wrote:
> * Anthony Liguori (anthony@codemonkey.ws) wrote:
>> The
>> virtio-net setup probably made extensive use of pinning and other tricks
>> to make things faster than a normal user would see them.  It ends up
>> creating a perfect combination of batching which is pretty much just
>> cooking the mitigation schemes to do extremely well for one benchmark.
>
> Just pinning, the rest is stock virtio features like mergeable rx buffers,
> GRO, GSO (tx mitigation is actually disabled).

Technically, tx mitigation isn't disabled.  The heuristic is changed 
such that instead of relying on a fixed timer, tx notification is 
disabled until you can switch to another thread and process packets.

The effect is that depending on time slice length and system load, you 
adaptively enable tx mitigation.  It's heavily dependent on the 
particulars of the system and the overall load.

For instance, this mitigation scheme looks great at high throughputs but 
looks very bad at mid-to-low throughputs compared to timer based 
mitigation (at least, when comparing CPU cost).

Regards,

Anthony Liguori
