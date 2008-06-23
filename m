Return-Path: <linux-kernel-owner+w=401wt.eu-S1757259AbYFWIjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbYFWIjD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 04:39:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbYFWIix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 04:38:53 -0400
Received: from web8715.mail.in.yahoo.com ([203.84.221.136]:32578 "HELO
	web8715.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751521AbYFWIix convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 04:38:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=dYelv/jSMnR+3Odj0sgf74DjlE2gQol2cwdD+Lb7xpNiUNjCQoC8PHGdmW1jcJcVKxUj69j+GCiGrDv7ozzb0WxDSFYf04YZmP5gEHOwHj6oEb1v8zoQfFT4XnmLj2iD+8edUgo08KZIJk1MoQfp8ThyhcbjsBDa48UIbTWfrrU=;
X-Mailer: YahooMailRC/975.45 YahooMailWebService/0.7.199
Date: Mon, 23 Jun 2008 14:08:49 +0530 (IST)
From: palani saravanan <busybeesaravanan0072003@yahoo.co.in>
Subject: Re: Behavior of lseek() on a fd opened with 'RDONLY' flag, when seeking goes beyond file size.
To: David Newall <davidn@davidnewall.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <887400.15277.qm@web8715.mail.in.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks David for clarification !

I ran this program in the kernel version, 'Linux 2.6.9-42.7.ELsmp'.
However, In a recent kernel version,  'Linux 2.6.24-19 ', the error EINVAL is returned as you mentioned.

Thanks,
Saravanan
----- Original Message ----
From: David Newall <davidn@davidnewall.com>
To: palani saravanan <busybeesaravanan0072003@yahoo.co.in>
Cc: linux-kernel@vger.kernel.org
Sent: Sunday, 22 June, 2008 7:36:12 AM
Subject: Re: Behavior of lseek() on a fd opened with 'RDONLY' flag, when seeking goes beyond file size.

palani saravanan wrote:
> Does lseek() permits -ve value as offset, with SEEK_SET mode? ...
>    errno = 0;
>    rd_rc = lseek(rd_fd, -10, SEEK_SET);
> returns rd_rc = -10 and errno remains 0.
>  

No, lseek does not permit negative file offsets, and should return
EINVAL in your example.  You may have discovered a bug.  For reference,
on my system lseek returns -1 and sets errno to EINVAL, as it should.

If you're running a recent kernel it might be worth looking closer into
this; for older kernels it's probably not worth the effort.



      Save all your chat conversations. Find them online at http://in.messenger.yahoo.com/webmessengerpromo.php
