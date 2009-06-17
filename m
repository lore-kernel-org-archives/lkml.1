Return-Path: <linux-kernel-owner+w=401wt.eu-S932417AbZFQDIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417AbZFQDIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 23:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932313AbZFQDHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 23:07:54 -0400
Received: from smtp-out.google.com ([216.239.33.17]:31145 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311AbZFQDHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 23:07:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=KD6pK0rrVp4AlE4YfcvIBcPldCJ2rUd61ZVM3jbpt4heLEPBDxHnskKB0OGD5E0wd
	9qTJ+p2Vv/sqfFf4yiIAA==
MIME-Version: 1.0
In-Reply-To: <20090615095259.3456de5c@lxorguk.ukuu.org.uk>
References: <1245033557-10968-1-git-send-email-swetland@google.com>
	 <1245033557-10968-2-git-send-email-swetland@google.com>
	 <20090615095259.3456de5c@lxorguk.ukuu.org.uk>
Date: Tue, 16 Jun 2009 20:07:51 -0700
Message-ID: <a55d774e0906162007l9d52db6n5da5f8613b3f328e@mail.gmail.com>
Subject: Re: [PATCH 1/3] [ARM] msm_serial: serial driver for MSM7K onboard 
	serial peripheral.
From: Brian Swetland <swetland@google.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       pavel@ucw.cz, Robert Love <rlove@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 1:52 AM, Alan Cox<alan@lxorguk.ukuu.org.uk> wrote:
> On Sun, 14 Jun 2009 19:39:15 -0700 Brian Swetland <swetland@google.com> wrote:
>
> The set_termios method also needs to properly propogate back the settings
> it actually used (in your case thats mostly the setting the actual speed
> selected).

Would something like:
   if (tty_termios_baud_rate(termios))
       tty_termios_encode_baud_rate(termios, baud, baud);

Be the reasonable thing to do?  8250.c seems to do that.

Thanks,

Brian
