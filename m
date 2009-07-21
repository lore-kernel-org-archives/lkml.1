Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbZGUPun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbZGUPun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 11:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755168AbZGUPul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 11:50:41 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42602 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755029AbZGUPul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 11:50:41 -0400
X-Sasl-enc: I1iKL9LIUG3zdXzig/vSlaVqAWDYUHHc30ojSMUhX7hN 1248191440
Date: Tue, 21 Jul 2009 12:50:38 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Michael Buesch <mb@bu3sch.de>
Cc: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thinkpad-acpi: Avoid heap buffer overrun
Message-ID: <20090721155038.GB22182@khazad-dum.debian.net>
References: <200907211216.18135.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907211216.18135.mb@bu3sch.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009, Michael Buesch wrote:
> Avoid a heap buffer overrun triggered by an integer overflow of the userspace
> controlled "count" variable.
> If userspace passes in a "count" of (size_t)-1l, the kmalloc size will overflow
> to ((size_t)-1l + 2) = 1, so only one byte will be allocated. However, copy_from_user()
> will attempt to copy 0xFFFFFFFF (or 0xFFFFFFFFFFFFFFFF on 64bit) bytes to the buffer.

Good catch.  Thank you!

Patch acked, and queued.  I am sending it to Len Brown now (although I think
he is taking his post-rc2 time off, so it might take a week or so for it to
be sent to Linus).

It is a security hole alright, and while it is NOT open in a default
configuration, it CAN be used for local priviledge escalation on any system
where the distro or the local administratior used chown() or chmod() to
unrestrict access to /proc/acpi/ibm/*.

The code in question is in mainline since 2.6.12, and maybe even earlier.
Argh.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
