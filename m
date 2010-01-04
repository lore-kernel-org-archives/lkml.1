Return-Path: <linux-kernel-owner+w=401wt.eu-S1753712Ab0ADRn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab0ADRn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 12:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215Ab0ADRn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 12:43:57 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:60127 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab0ADRn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 12:43:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:bcc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=IE58CcPsxjGvZOP4Wj9gWk7vUdMi0y39A2ilVueCXv9tmk+A6qjATZ2SewMdx1m444
         8gJBCx+2T5MbjMqzoNbNXrzQm2QdtdCHZOJWucRAraRAn2nHJ5bCdUMivv8FbzeaN07q
         Vp7wdSZVAhyMVgFPoGQ5qHAFsrnzDRSYQ3h6g=
Date: Mon, 4 Jan 2010 18:43:52 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: USB: serial: kfifo_len locking
Message-ID: <20100104174352.GA26606@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefani,

I noticed that the locking that used to protect kfifo_len in
usb_serial_generic_chars_in_buffer was removed when the kifo api changed
to not use internal locking (c1e13f25674ed564948ecb7dfe5f83e578892896 -- 
kfifo: move out spinlock). 

Was this intentional?

I found a related discussion here

	http://lkml.org/lkml/2009/12/18/433

where you seem to say that no such locking is required as long as
kfifo_reset is never called (and that one could use kfifo_reset_out
instead)?

However, kfifo_reset was still being called when the locking was removed
and not until later was it changed to kfifo_reset_out
(119eecc831a42bd090543568932e440c6831f1bb -- Fix usb_serial_probe()
problem introduced by the recent kfifo changes).  

Does this last change imply that no locking in
usb_serial_generic_chars_in_buffer is required? If this is the case,
perhaps such locking guidelines could be added to kfifo.h?

Thanks,
Johan

