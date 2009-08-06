Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbZHFTcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbZHFTcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 15:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756528AbZHFTcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 15:32:21 -0400
Received: from mail-yw0-f177.google.com ([209.85.211.177]:55371 "EHLO
	mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791AbZHFTcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 15:32:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=jtB7K8ELjbkl7YEwFEPAs4+aDCbLQl0sJsffO4sFCOBcLEtP78lbjDVG9Kqo69unaH
         tl0fY1EfupOm3YRI+C0xD1iogIKZLDSQeHLvJDoskhvdGJBO2ufM6zuIHBMmM3pRbYjT
         ZW3ffkhGBdewzw3RtSA6a5kJl600rVYUS2CzI=
MIME-Version: 1.0
In-Reply-To: <b637ec0b0908061226m33203bco7ac38cecb939b382@mail.gmail.com>
References: <b637ec0b0908061130w399eb1c6oc3a31640a76398c5@mail.gmail.com> 
	<20090806183247.GI26809@tuxdriver.com> <b637ec0b0908061226m33203bco7ac38cecb939b382@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 6 Aug 2009 12:32:00 -0700
Message-ID: <43e72e890908061232k467ba1f7iece5d0aa9bece811@mail.gmail.com>
Subject: Re: WARNING: at net/mac80211/mlme.c:2292 ieee80211_sta_work+0x97/0xd2d 
	[mac80211]()
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 6, 2009 at 12:26 PM, Fabio Comolli<fabio.comolli@gmail.com> wrote:
> Hi John. I'm using ath5k .
>
> The card is a:
>
> 01:00.0 Ethernet controller: Atheros Communications Inc. AR5001
> Wireless Network Adapter (rev 01)
>
> with PCI ID:
>
> 01:00.0 0200: 168c:001c (rev 01)

What kernel?

This is probably a driver/mac80211 adding work into the mac80211
workqueue during the susend --> resume cycle. We recently changed the
warning to be moved onto the actual caller who does the queue_work()
so we don't have to guess at this and do a painful debugging.

I suspect you are not using the latest wireless-testing.

  Luis
