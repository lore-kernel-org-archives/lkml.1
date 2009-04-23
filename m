Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbZDWSQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbZDWSQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 14:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbZDWSQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 14:16:00 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:40186 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750704AbZDWSP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 14:15:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0jQInAVbjh/v3yZo8mZwsCiFYbY02yJ9j78O0ToNj4DrL+EKywUPBJzdYlidNJ61z/N7Y1YU1/jVI5HMYtdhBLN+WBUbhAU1rgvkd+r5NqlDz/kFPZn3HtedKZAjLO7O0xyREkhoVydTu9q5BVrUqW66ycbOxQuIK2JdOEDKcl0=  ;
X-YMail-OSG: m7t_KL8VM1kkKw0seHtuxfkLwgFLo.72cBRPRiPD9V41USwqtJ1iyLA_cm.Vy0bw3o5b143b7qbDVAskmlcgUUg00tEXB8WRoncFB_KoOSBpldQ8JdxlzQeoubWr_DGtcCowqErPNXAaEtgJJl_.iuIkm6Nvupd56.qO7Ep6Nw_0BockxpXafEQRkVU6FqmKvssWAC49QFMOmcly31lj2fhUY1DGnD._dlQn_0m3BgH8twGQ0D6._9O9MoolLN990JY7dLKcpGdIALZ2frIYOAY5FIVp9peead3CBZlGU9FCZQoB3zT.
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: [PATCH] rtc: Make rtc_update_irq callable with irqs enabled
Date: Thu, 23 Apr 2009 11:15:56 -0700
User-Agent: KMail/1.9.10
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, akpm@linux-foundation.org,
       rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       hcegtvedt@atmel.com, vapier@gentoo.org, rongkai.zhan@windriver.com,
       balajirrao@openmoko.org, broonie@opensource.wolfsonmicro.com
References: <20090410005820.4fcfcc1f@i1501.lan.towertech.it> <20090424.002900.11623503.anemo@mba.ocn.ne.jp> <20090423174641.2b03e7a7@i1501.lan.towertech.it>
In-Reply-To: <20090423174641.2b03e7a7@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200904231115.57525.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 April 2009, Alessandro Zummo wrote:
>  Is not an API change, we are gradually relaxing it if it
>  proves workable :)

Erm, it *is* an API change at least to the extent that
the last version of the patch made the interface spec
become incorrect.

Current interface spec *requires* that function to be
called with IRQs disabled.

The downside of that spec is that there's no way to test
it, since CONFIG_LOCKDEP doesn't understand that almost
all IRQ handlers don't disable IRQs.  So there are some
bugs in RTC drivers that can only be uncovered by code
review.

- Dave
