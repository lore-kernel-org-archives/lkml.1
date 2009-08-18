Return-Path: <linux-kernel-owner+w=401wt.eu-S1758875AbZHRMgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875AbZHRMgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 08:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757212AbZHRMgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 08:36:09 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:22757 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbZHRMgI convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-GHaskins@novell.com;5:2>);
	Tue, 18 Aug 2009 08:36:08 -0400
Message-Id: <4A8A67F70200005A000528F8@sinclair.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 Beta 
Date: Tue, 18 Aug 2009 06:36:07 -0600
From: "Gregory Haskins" <GHaskins@novell.com>
To: <avi@redhat.com>
Cc: <mingo@elte.hu>, <gregory.haskins@gmail.com>,
       <alacrityvm-devel@lists.sourceforge.net>, <mst@redhat.com>,
       <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 3/6] vbus: add a "vbus-proxy" bus model
References: <4A8A67ED0200005A000528F5@sinclair.provo.novell.com>
 <4A8A67F70200005A000528F8@sinclair.provo.novell.com>
In-Reply-To: <4A8A67F70200005A000528F8@sinclair.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah, I agree.  I am not advocating we expend energy on this now.  But my thoughts at the time were that that particular problem can be solved at io-setup time with some kind of call to qualify the address.

Iow: a slow path call with the address would return flags on whether iowrite() should do a real io, or a IOoHC.

-greg
 
-----Original Message-----
From: Avi Kivity <avi@redhat.com>
To: Gregory Haskins <GHaskins@novell.com>
Cc:  <mingo@elte.hu>
Cc:  <gregory.haskins@gmail.com>
Cc:  <alacrityvm-devel@lists.sourceforge.net>
Cc:  <mst@redhat.com>
Cc:  <kvm@vger.kernel.org>
Cc:  <linux-kernel@vger.kernel.org>
Cc:  <netdev@vger.kernel.org>

Sent: 8/18/2009 6:29:08 AM
Subject: Re: [PATCH v3 3/6] vbus: add a "vbus-proxy" bus model	 for

On 08/18/2009 03:24 PM, Gregory Haskins wrote:
> (Again on the top post)
>
> No, Avi, nothing has changed to my knowledge.  I just saw that you and Michael were heading down the same path, so I thought I might interject that we've already covered that ground.
>
> As of right now, I am of the opinion that its not worth any change in the short term, and may be worth IOoHC in the long term (primarily so that mmios get a boost)
>    

The primary issue with IOoHC is that while hypercalls are faster than 
emulated mmio, they're much slower than assigned mmio.  So we have to 
distinguish between these two cases, which gets kinda icky.

-- 
error compiling committee.c: too many arguments to function


