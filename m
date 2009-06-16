Return-Path: <linux-kernel-owner+w=401wt.eu-S1760722AbZFPUZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760722AbZFPUZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZFPUYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:24:53 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:57412 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbZFPUYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:24:52 -0400
X-Greylist: delayed 1390 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Jun 2009 16:24:52 EDT
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Organization: Mandriva
To: LKML <linux-kernel@vger.kernel.org>
Subject: staging driver s626 clashes with philips SAA7146 media/dvb based cards
Date: Tue, 16 Jun 2009 17:01:44 -0300
User-Agent: KMail/1.11.90 (Linux/2.6.30-desktop-1mnb; KDE/4.2.90; i686; ; )
Cc: Greg KH <gregkh@suse.de>, Gianluca Palli <gpalli@deis.unibo.it>,
       David Schleef <ds@schleef.org>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       Ian Abbott <abbotti@mev.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200906161701.45234.herton@mandriva.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The s626 (comedi) driver in staging conflicts with philips SAA7146 media/dvb
based cards, because it claims the same vendor:device pci id for all 
subdevice/subvendor ids. What happens is that for people that have a philips 
SAA7146 based card, s626 if available gets loaded by udev and makes system 
freeze (https://qa.mandriva.com/show_bug.cgi?id=51445).

Looks like s626 shouldn't claim all 1131:7146 devices, either by specifying 
specific subdevice/subvendor ids specific to s626 devices or doing additional 
checks in its probe/attach function.

--
[]'s
Herton
