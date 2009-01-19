Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbZASArA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbZASArA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 19:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755031AbZASAqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 19:46:50 -0500
Received: from hydra.ck.polsl.pl ([157.158.1.11]:48673 "EHLO hydra.ck.polsl.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754900AbZASAqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 19:46:50 -0500
Date: Mon, 19 Jan 2009 01:46:46 +0100
From: Adam Osuchowski <adwol@zonk.pl>
To: linux-kernel@vger.kernel.org
Subject: Strange leases behaviour
Message-ID: <20090119004646.6b8b4567@zonk.pl>
Reply-To: Adam Osuchowski <adwol@zonk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel 2.6.28 and such a situation:

- process A obtains read lease on file via fcntl(fd, F_SETLEASE, F_RDLCK).
- while process A holds lease, process B tries to open this file for writing,
  what, of course, leads to block process B on open().
- while process A holds lease and process B waits on open(), process C
  tries to open the same file for reading.

Then, process C also blocks on open(), even though it calls open() only
for reading. Even if process B terminates before process A removes lease,
process C still can't open file for reading. But if process B doesn't try
to open file for writing, process C can open it for reading without any
trobule.

Why there is such a bahaviour? Is it not a bug?

Regards.
