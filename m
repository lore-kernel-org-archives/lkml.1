Return-Path: <linux-kernel-owner+w=401wt.eu-S1760375AbZIPXRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760375AbZIPXRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 19:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760293AbZIPXRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 19:17:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38790 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456AbZIPXRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 19:17:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Karol Lewandowski <karol.k.lewandowski@gmail.com>
Subject: Re: [BUG 2.6.30+] e100 sometimes causes oops during resume
Date: Thu, 17 Sep 2009 01:18:53 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "Graham, David" <david.graham@intel.com>
References: <20090915120538.GA26806@bizet.domek.prywatny>
In-Reply-To: <20090915120538.GA26806@bizet.domek.prywatny>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909170118.53965.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 September 2009, Karol Lewandowski wrote:
> Hello,
> 
> I'm getting following oops sometimes during resume on my Thinkpad T21
> (where "sometimes" means about 10/1 good/bad ratio):
> 
> ifconfig: page allocation failure. order:5, mode:0x8020

Well, this only tells you that an attempt to make order 5 allocation failed,
which is not unusual at all.

Allocations of this order are quite likely to fail if memory is fragmented,
the probability of which rises with the number of suspend-resume cycles already
carried out.

I guess the driver releases its DMA buffer during suspend and attempts to
allocate it back on resume, which is not really smart (if that really is the
case).

Thanks,
Rafael
