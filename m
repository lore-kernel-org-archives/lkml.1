Return-Path: <linux-kernel-owner+w=401wt.eu-S1757358AbZFHXNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbZFHXNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 19:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402AbZFHXNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 19:13:05 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:21481 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbZFHXND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 19:13:03 -0400
X-IronPort-AV: E=Sophos;i="4.41,326,1241395200"; 
   d="scan'208";a="319338787"
Date: Mon, 8 Jun 2009 16:13:05 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-usb@vger.kernel.org, greg@kroah.com, linux-scsi@vger.kernel.org,
       netdev@vger.kernel.org, arjan@infradead.org
Subject: Re: [PATCH 7/7] initdev:kernel:Await block device discovery
Message-ID: <20090608231305.GA28992@cuplxvomd02.corp.sa.net>
References: <20090606023416.GA5798@cuplxvomd02.corp.sa.net> <4A2A3F36.4070408@s5r6.in-berlin.de> <20090608223019.GC22222@cuplxvomd02.corp.sa.net> <4A2D96C5.2080604@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2D96C5.2080604@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-3; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 12:55:01AM +0200, Stefan Richter wrote:
> David VomLehn wrote:
>> On Sat, Jun 06, 2009 at 06:04:38AM -0400, Stefan Richter wrote:
>>> 1.)  It depends on the rootdelay so big that it is guaranteed that 
>>> one or more initdev_found() have been called before 
>>> prepare_namespace()'s ssleep(root_delay) is over.
> ...
>> I think you misunderstood.  Buses are enumerated before this code is
>> reached and thus initdev_found() has already been called for all attached
>> block devices.
> ...
>> I would appreciate it if you could take a closer look at the locations where
>> initdev_found() and initdev_probe_done() are called and see if you still
>> think there is a problem.
>
> I obviously need to do that.
>
> However, one issue remains:  If somebody wants to use your API for  
> another bus, he needs to know at which point he can successfully use it,  
> and after what point (or context) it cannot, even must not, be used  
> anymore.  This isn't documented --- or is it?

Hmm, I tried to make this clear in Documentation/driver-model/initdev.txt,
but I don't claim to be much of a writer and am open to suggestions.

> (By 'buses are enumerated before...' you surely mean only the buses for  
> which you implemented this API usage already.)

Yes, definitely. In an ideal world, every bus which might have a console,
network, or block device would be using this API. USB is a big problem for
me, so that's the itch I scratched. Alan Stern also gave a rub to SCSI.
If people are using devices on, say, Firewire, they will have whatever
behavior they had before the introduction of the API.

> Stefan Richter

David VomLehn
