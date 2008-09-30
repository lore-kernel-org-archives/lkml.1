Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbYI3MtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbYI3MtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 08:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYI3Ms7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 08:48:59 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:62021 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbYI3Ms6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 08:48:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Z89oSV5OMOfbQ3a0s+BWel8xweUHvATfpqo04JaKjLHlo0s8ZxiAfJ9cXAFvwkDQia
         1RIq/r4gqTHLsSIxDKHeRSwsV9I6OjAlbnCYMyB+uGCBou9uE7/hZe3so+SxPPXMmmVx
         /cbdNm0sjlbMguSMT0Gqa2Dqz3CSSahKlVsVc=
Message-ID: <806dafc20809300548y4af5f10bs8a80caa24f176c79@mail.gmail.com>
Date: Tue, 30 Sep 2008 08:48:55 -0400
From: "Monty Montgomery" <monty@xiph.org>
To: "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [regression] CD-DA delay needed after insertion (http://bugzilla.kernel.org/show_bug.cgi?id=10974)
Cc: "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       linux-scsi@vger.kernel.org,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0809301430370.5818@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be>
	 <1213648258.3420.12.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0806171530340.22840@vixen.sonytel.be>
	 <1214605634.3394.91.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0806301120570.10868@vixen.sonytel.be>
	 <1214841102.3381.5.camel@localhost.localdomain>
	 <1214925487.3316.12.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0809171701330.21347@vixen.sonytel.be>
	 <806dafc20809300117u2806e37bx986b54543862f358@mail.gmail.com>
	 <Pine.LNX.4.64.0809301430370.5818@vixen.sonytel.be>
X-Google-Sender-Auth: fd217cbad0eb17fd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> | 0x0ffd5730 in cdda_read_timed () from /usr/lib/libcdda_interface.so.0
> | (gdb) bt
> | #0  0x0ffd5730 in cdda_read_timed () from /usr/lib/libcdda_interface.so.0
> | #1  0x0ffa7624 in i_read_c_block () from /usr/lib/libcdda_paranoia.so.0
> | #2  0x0ffa9114 in paranoia_read_limited () from /usr/lib/libcdda_paranoia.so.0
> | #3  0x10004da0 in ?? ()
> | #4  0x0fd46704 in ?? () from /lib/libc.so.6
> | #5  0x0fd468c0 in __libc_start_main () from /lib/libc.so.6
> | #6  0x00000000 in ?? ()
>
> due to the `buffer' parameter being NULL.

Oh, good catch.  Platform/drive combination that hadn't been tripped
here.  Fixing in SVN now.

(you're on bigendian or using an old bigendian SCSI drive?)

Monty
