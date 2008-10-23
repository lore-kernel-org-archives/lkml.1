Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbYJWJR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbYJWJR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 05:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbYJWJRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 05:17:50 -0400
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:57536 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbYJWJRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 05:17:49 -0400
Message-ID: <49004133.7090805@freemail.hu>
Date: Thu, 23 Oct 2008 11:17:39 +0200
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: video4linux-list@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: cafe_ccic: possible reason why gqcam is not working
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01d.mail.t-online.hu 32710; Body=3 Fuz1=3
	Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Jonathan,

I read in your documentation found at linux-2.6.27/Documentation/video4linux/cafe_ccic, and
found that you mention that "gqcam" is not working together with cafe_ccic.

I have done some investigation of the gqcam 0.9.1-4 found in Debian system. I wanted
to use gqcam with a different webcam and found out the following things:

 - gqcam currently only supports video4linux 1, and it uses the following
   ioctls: VIDIOCSPICT, VIDIOCSWIN, VIDIOCGCAP, VIDIOCGWIN and VIDIOCGPICT.

 - gqcam only supports read() method of getting the frames.

 - gqcam currently has a limitation that it allocates a static buffer size of
   640*480*3 bytes. This is defined in gqcam.h, struct Camera, field rawbuffer.

As I came across with this buffer limitation, I created a simple patch which at least
can warn the user about this problem instead of getting segmentation fault. The
patch available at http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=502350 .

I hope this helps you to track down why gqcam is not working with cafe_ccic.

Regards,

	Márton Németh
