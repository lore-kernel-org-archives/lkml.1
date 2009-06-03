Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609AbZFCXTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbZFCXTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 19:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754585AbZFCXTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 19:19:33 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:48734 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbZFCXTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 19:19:33 -0400
From: Goswin von Brederlow <goswin-v-b@web.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Goswin von Brederlow <goswin-v-b@web.de>
Subject: include/linux/aio_abi.h and IOCB_CMD_POLL
Date: Thu, 04 Jun 2009 01:18:50 +0200
Message-ID: <87d49k6h45.fsf@frosties.localdomain>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.22 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX1+xoROhG7zr37jSAm83ihg8KX2hXrfx0g0Rw5Bj
	jwQZbgAfGh+oTtqRXO0Ukf88ValZ1psqlua22YL9WfHT7tKRXG
	HcUh6zkVM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

please CC me on replies.

I'm trying to write a fuse filesystem in ocaml using asynchronous
IO. For that to work nicely I need to poll /dev/fuse for incoming
requests without reading data from it (libfuse does that when called,
I just need to know when I can call it without it blocking).

Now to my problem. The header file for libaio says:

| /* Jeff Moyer says this was implemented in Red Hat AS2.1 and RHEL3.
|  * AFAICT, it was never in mainline, and should not be used. --RR */
| static inline void io_prep_poll(struct iocb *iocb, int fd, int events)

I tried using it anyway but all I got was an error that /dev/fuse is
not seekable. I also looked in the kernel source and didn't see any
implementation for poll there.

So my questions now are:

1) Why was this never adapted into mainline?
2) Do you know if there is any patch for it against a recent kernel?
3) Are there any alternatives to libaio that don't use threads and
   support polling?

MfG
        Goswin
