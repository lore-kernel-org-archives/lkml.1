Return-Path: <linux-kernel-owner+w=401wt.eu-S1751594AbZLMS3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbZLMS3z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 13:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbZLMS3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 13:29:54 -0500
Received: from claw.goop.org ([74.207.240.146]:60598 "HELO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750832AbZLMS3x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 13:29:53 -0500
Message-ID: <4B2532A0.2070001@goop.org>
Date: Sun, 13 Dec 2009 10:29:52 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091203 Fedora/3.0-3.13.rc2.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Poor KVM guest performance on an HP rack server
References: <4B243B2B.806@pardus.org.tr> <4B24856A.4020507@goop.org> <4B24BE17.805@pardus.org.tr>
In-Reply-To: <4B24BE17.805@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/09 02:12, Ozan Çağlayan wrote:
> Hmm, that's because we're using/developing a Linux distribution which
> doesn't have 64-bit support yet. But since the guest will be a
> compile-farm for our needs, it's worth trying to run an 64-bit distro on
> the host to see the difference, thanks for the tip but how much should
> this affect the performance?

32-bit PAE is marginal above 4G of memory and the limit is at about 8G.  
Above that, so much lowmem (<~1GB) is occupied by page and other kernel 
structures that there's barely any memory to do any real work.  If this 
is what's happening, you'd expect to see poor host performance, and slow 
guest performance would be secondary to that.

With 64-bit, all the memory can be directly addressed so none of this 
applies.  I would expect to see significant performance gains.

There's nothing to stop you from running 32-bit PAE guests, so you can 
do your distro development that way (at least in part).

     J
