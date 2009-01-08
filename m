Return-Path: <linux-kernel-owner+w=401wt.eu-S1763596AbZAHWs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763596AbZAHWs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 17:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763316AbZAHWsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 17:48:04 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:9122 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759606AbZAHWsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:48:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eih6zeXZ8LyYfxBdnpzoPboTHS8UjeJqoTP28AmABci2NpAnWliFjm8IHm2oo3gGnR
         giqoXzhxtXmmkieDGePXlLwWE9hvMmamUISznK/bxhRokWjInlerDMX2THNkGByIfVWf
         O0f7mssz2vNq+/8vLzwf5a0FAmg4a9nhMjDOo=
Message-ID: <c384c5ea0901081447i5ad807b3yb0ec3adebeaa46a0@mail.gmail.com>
Date: Thu, 8 Jan 2009 23:47:58 +0100
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "Thiago Galesi" <thiagogalesi@gmail.com>
Subject: Re: FPGA programming driver architecture
Cc: "Hugo Villeneuve" <hugo@hugovil.com>,
       "Florian Fainelli" <florian@openwrt.org>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
In-Reply-To: <82ecf08e0901081414u15af3c2dy9c88a242db024dc7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081212150314.6ea24996.hugo@hugovil.com>
	 <200812131358.03010.florian@openwrt.org>
	 <20090108151827.72f50cee.hugo@hugovil.com>
	 <82ecf08e0901081414u15af3c2dy9c88a242db024dc7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 8, 2009 at 11:14 PM, Thiago Galesi <thiagogalesi@gmail.com> wrote:
>> > > Hi,
>> > > I have written some code to program a FPGA in Linux, for two
>> > > different types of boards: one uses a serial interface (SPI) and
>> > > the second a parallel interface. I have been able to sucessfully
>> > > program both boards. I'm now trying to clean my code and make it
>> > > more generic, as well as better in line with the Linux driver
>> > > model.
>
> Considering the several FPGA models available and ways to program it,
> I guess the important thing to consider is what can be made generic.

Indeed.

The programming back end should be generic enough so that it can use
other subsystems.

The FPGA configuration interface could be on the memory bus (and in
many cases the DMA helpers can be used) or behind a PCI bus, or can
even have SPI etc front-ends.

In general the programming API should accept a blob of data,
preferably in one chunk (pointer plus length) or at least 4kB chunks
or so, so that configuration is not severy overheaded by a callback
per byte (or even bit).

Regards,
-- 
Leon
