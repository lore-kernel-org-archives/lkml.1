Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbYELIRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbYELIRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 04:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756182AbYELIQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 04:16:59 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:44333 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754906AbYELIQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 04:16:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ZgIDIfyefKJb5bWAj/DWBAx0mvT/GAZMBDe+aED76Vz/DY6RjyviTn18ofO1vkenU3JWRhwpL+GJ7yfTdoI7uNCHTimNRt9S9f7VTUpIPl6HMtAMiyPnLpHsdA++gul93h6hb/OGac/TqQjvZpswDv915yMcs00liXpCdZwK+3o=  ;
X-YMail-OSG: MpOPLOYVM1mzPskfWfceP.SGX6NXE2C6hp8473V5uf2qziq.bUqOBIHtso5Oz3n8rc4kuF6ALr1DiuSUKecYTnZGdakGt4Y9BjjMkzTjYU4Tq_gqLpsHXmoRYn5K8pSZWcY-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: drivers/usb/misc/usbtest.c weirdness
Date: Mon, 12 May 2008 01:02:22 -0700
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb@vger.kernel.org
References: <20080511202222.GP19058@joi>
In-Reply-To: <20080511202222.GP19058@joi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805120102.23320.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 May 2008, Marcin Slusarz wrote:
> 
> test_ctrl_queue expects (?) positive and negative errnos.
> what is going on here?

The sign is just a way to flag something:

                /* some faults are allowed, not required */

The negative ones are required.  Positive codes are optional,
in the sense that, depending on how the peripheral happens
to be implemented, they won't necessarily be triggered.

For example, the test to fetch a device qualifier desriptor
must succeed if the device is running at high speed.  So that
test is marked as negative.  But when it's full speed, it
could legitimately fail; marked as positive.  And so on for
other tests.

Look at how the codes are *interpreted* to see it work.
