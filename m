Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbXIRSMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbXIRSMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 14:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbXIRSMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 14:12:32 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3787 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755308AbXIRSMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 14:12:30 -0400
X-Server-Uuid: 6B5CFB92-F616-4477-B110-55F967A57302
Subject: Re: bnx2 dirver's firmware images
From: "Michael Chan" <mchan@broadcom.com>
To: "Denys Vlasenko" <vda.linux@googlemail.com>
cc: linux-kernel@vger.kernel.org, "David Miller" <davem@davemloft.net>,
       "netdev" <netdev@vger.kernel.org>
In-Reply-To: <200709181855.37598.vda.linux@googlemail.com>
References: <200709181823.26429.vda.linux@googlemail.com>
 <1190141114.9540.216.camel@dell>
 <200709181855.37598.vda.linux@googlemail.com>
Date: Tue, 18 Sep 2007 12:09:52 -0700
Message-ID: <1190142592.9540.218.camel@dell>
MIME-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8)
X-WSS-ID: 6AEECA883K42796267-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-18 at 18:55 +0100, Denys Vlasenko wrote:
> On Tuesday 18 September 2007 19:45, Michael Chan wrote:
> > We can compress all the different sections of the firmware.  Currently,
> > we only compress the biggest chunks and the rest are uncompressed.
> 
> > These zeros should compress to almost nothing.  But I agree that the
> > firmware is still big.
> 
> You don't need to store and fetch zeros at all. You *know* that
> they are zeros, right? So do this:
> 
> -                         REG_WR_IND(bp, offset, fw->bss[j]);
> +                         REG_WR_IND(bp, offset, 0);
> 
Good point.  We can do that.  Looking at the file, there are other non-
zero data that can be compressed to save some more room.

