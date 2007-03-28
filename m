Return-Path: <linux-kernel-owner+w=401wt.eu-S1751542AbXC1NYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbXC1NYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 09:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbXC1NYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 09:24:36 -0400
Received: from inetc.connecttech.com ([64.7.140.42]:1859 "EHLO
	inetc.connecttech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbXC1NYf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 09:24:35 -0400
From: "Stuart MacDonald" <stuartm@connecttech.com>
To: "'Oliver Neukum'" <oliver@neukum.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: RE: question on tty open and close
Date: Wed, 28 Mar 2007 09:22:15 -0400
Organization: Connect Tech Inc.
Message-ID: <019201c7713c$1a3277c0$294b82ce@stuartm>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook, Build 10.0.6626
In-Reply-To: <200703281516.31366.oliver@neukum.org>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Neukum [mailto:oliver@neukum.org] 
> Am Mittwoch, 28. März 2007 15:10 schrieb Stuart MacDonald:
> > > We find that a failure in open() leads to release_dev() 
> being called.
> > > release_dev() calls close():
> > > 
> > >       if (tty->driver->close)
> > >               tty->driver->close(tty, filp);
> > > 
> > > So we have a file that's closed although open() never succeeded?
> > 
> > That's correct! It's been a pain in my butt for years.
> 
> How did you deal with that proctological issue?

Just make sure the close() handles the situation properly. It makes
reference counting...  fun.

The serial driver has always handled it like this.

..Stu

