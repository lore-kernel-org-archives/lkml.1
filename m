Return-Path: <linux-kernel-owner+w=401wt.eu-S1752550AbZI0Rpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbZI0Rpf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 13:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbZI0Rpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 13:45:34 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:28611 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbZI0Rpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 13:45:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tWetYU2rcik+U5RbXwm5JWPX7CfvEeQcXz5OjmcmWeavTOGeu5K3z9LXxl3pEeCHtG
         lm1a7DKL12mdEODkhOQ609AnyrxXZgp/2TxDm1NzALf8JY7p/CfBYcCQhJd+gew+QeQo
         qlpsOGlmXylrLDd20mo4Qm1tqOTkgi3jGKKHE=
Subject: Re: USB HDD boot panic (2.6.31)
From: Calvin Walton <calvin.walton@gmail.com>
To: Ben Ryan <ben@impulse.net.au>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <002701ca3d9b$53250240$f96f06c0$@net.au>
References: <002701ca3d9b$53250240$f96f06c0$@net.au>
Content-Type: text/plain
Date: Sun, 27 Sep 2009 13:45:33 -0400
Message-Id: <1254073533.9459.4.camel@ayu>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-25 at 14:47 +1000, Ben Ryan wrote:
> I've a question regarding boot from USB-attached IDE HDD under 2.6.31
> (slackware/lilo).

> From what I can gather the USB drivers aren't finished initialising before
> the disks are enumerated and mapped to /dev.
> 
> Is this a known, current issue?
> Does anyone have a patch that can help? If so, why isn't it mainlined?
> (Please CC responses!)

This is a bit of a known issue, because USB simply doesn't have a way of
letting you know when scanning for devices has been completed. Current
versions of linux have a simple workaround: add "rootwait" to your
kernel command line in LILO.

(from Documentation/kernel-parameters.txt:)
        rootwait        [KNL] Wait (indefinitely) for root device to show up.
                        Useful for devices that are detected asynchronously
                        (e.g. USB and MMC devices).

Alternately, you can use an initramfs which is set up to wait for the
device to appear. The rootwait option is off by default in order to
speed up booting under normal circumstances.

> Thanks
> Ben

-- 
Calvin Walton <calvin.walton@gmail.com>

