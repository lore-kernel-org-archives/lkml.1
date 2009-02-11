Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbZBKHXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbZBKHXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 02:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbZBKHXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 02:23:36 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:41328 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752556AbZBKHXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 02:23:35 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mgZQG48p9LlaPqhEkWx3C6Mvz4NPnHg9ngvEqB9dySKaEGlDmw1LYmD1KzrgXDbV+TxcsVt7yp1Dp+BXU3J2mGtK3rD0l/KZ1IY9v6+BlGzem2uKAqNHtBigXRsuz9l8xPcbGgfr0cCVa8s9sBr64QqRXMudF6WnbVaQm/FrXns=  ;
X-YMail-OSG: NVsVjq4VM1kN2v7WhlpRp_Bxn2rHQGTn4hQl8IMTYR70fS_4DAAnzwMEp.jf52KPSntFP4tFr1ETGTT_n2X2naABgtrucN7m.NPf85lYl2lSvI05hbeLd1Fcsb1.pUia6HzCqB8dCsxC0aeKPeYmfMjY
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Kalle Jokiniemi <kalle.jokiniemi@digia.com>
Subject: Re: [PATCH 0/2] TWL: USB: Start using twl4030/5030 regulator driver
Date: Tue, 10 Feb 2009 23:23:30 -0800
User-Agent: KMail/1.9.10
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
       jouni.hogander@nokia.com, broonie@sirena.org.uk
References: <> <1234336002-26372-1-git-send-email-kalle.jokiniemi@digia.com>
In-Reply-To: <1234336002-26372-1-git-send-email-kalle.jokiniemi@digia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902102323.30395.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 February 2009, Kalle Jokiniemi wrote:
> These couple of patches enable dynamic swithcing of the
> regulators used by twl4030 usb tranceiver.
> 
> This set replaces the single patch "USB: disable twl4030
> USB regulators when cable unplugged" sent previously.
> The change to previous version is that possible errors
> in regulator_get are now handled and the twl4030 usb
> driver requires TWL_REGULATOR support to be compiled.

It'd make more sense to me as a single patch ... :)

And also, instead of *continuing* after the regulators
can't be acquired, it's better to abort.  It's not
going to be able to do anything ... so don't finish
probing, and don't register this "dead" transceiver.

- Dave
