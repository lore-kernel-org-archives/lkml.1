Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbZCNQnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbZCNQnR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 12:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbZCNQnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 12:43:04 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:54915 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbZCNQnD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 12:43:03 -0400
From: Markus <M4rkusXXL@web.de>
To: lkml <linux-kernel@vger.kernel.org>
Subject: REGRESSION: 2.6.28.7 => 2.6.29-rc8: pwc mmap always failes with EAGAIN
Date: Sat, 14 Mar 2009 17:42:53 +0100
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903141742.53496.M4rkusXXL@web.de>
X-Provags-ID: V01U2FsdGVkX18sUWkwOMTRXXtVGOy+e95hgZ+v3XNqB+0VKTJy
	PGzuPLA7mmxKqb1C/IO/qXFatwQP78AXuIDFEG4mx8/7UdfaiW
	p93VTkq2E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I just tried the 2.6.29-rc8 and run into a problem.
Running motion (a motion detection software for a webcam: 
http://www.lavrsen.dk/twiki/bin/view/Motion/WebHome) with the pwc 
driver will give some error message:
[1] Error mapping buffer 0 mmap: Resource temporarily unavailable
[1] MAP_FAILED: Resource temporarily unavailable

Looking in the sources:
It opens the video device (/dev/video1 for me) and then tries to mmap 
with:
mmap(NULL, buf.length, PROT_READ | PROT_WRITE, MAP_SHARED, s->fd, 
buf.m.offset);

It returns MAP_FAILED and errno is EAGAIN.
>From the manpages of mmap:
"EAGAIN   The file has been locked, or too much memory has been locked 
(see setrlimit(2))."

The software is not able to gather a picture from the webcam (its a 
logitech orbit). Everything works with kernel 2.6.28.7 and before. The 
config is copied from the 2.6.28.7 (except of some new options: "make 
oldconfig"). Nothing else is changed! (Only the kernel differs.)


I dont know how that can be debugged further as the pwc module wasn 
changed (except of a small api-adjustment).

Thanks!

Markus

PS: Please CC me!
