Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbZKSQVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbZKSQVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 11:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756890AbZKSQVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 11:21:38 -0500
Received: from fanny.its.uu.se ([130.238.4.241]:39822 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756651AbZKSQVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 11:21:37 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19205.28811.911525.832480@pilspetsen.it.uu.se>
Date: Thu, 19 Nov 2009 17:21:31 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k <linux-m68k@vger.kernel.org>,
       uClinux development list <uclinux-dev@uclinux.org>,
       linux-kernel@vger.kernel.org
Subject: Re: TIF_NOTIFY_RESUME on m68k?
In-Reply-To: <10f740e80911181202l6cca6b41m827f2c51f639d1f0@mail.gmail.com>
References: <10f740e80911181202l6cca6b41m827f2c51f639d1f0@mail.gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven writes:
 > Has anyone already looked into TIF_NOTIFY_RESUME support for m68k?

You need to change your entry.S code where it now does single-bit tests
for TIF_SIGPENDING with lsl/jmi do_signal_return, to instead test a 2-bit
(or larger, it that gives better code) flag field for zero/non-zero.
TIF_SIGPENDING and TIF_NOTIFY_RESUME should be alone in that field.
In the non-zero case you should call a new do_notify_resume() written in C,
which will then test TIF_SIGPENDING and TIF_NOTIFY_RESUME just like many
other archs do.

BTW, m68k also lacks TIF_RESTORE_SIGMASK support. You could probably use
the one I added to ARM very recently as a model.

Do current 2.6.3x m68k kernels boot on aranym? Last time I tried aranym
it could only boot som ancient hacked 2.4 kernel, for 2.6 kernels I got
disk detection errors due to what looked like byteswapping issues.
