Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678Ab0A1Hri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab0A1Hri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 02:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220Ab0A1Hrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 02:47:37 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:40166 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab0A1Hrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 02:47:36 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] hid: Logitech G13 driver 0.0.4
Date: Thu, 28 Jan 2010 08:47:50 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc3-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>,
       Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       felipe.balbi@nokia.com, jayakumar.lkml@gmail.com,
       linux-fbdev@vger.kernel.org, krzysztof.h1@wp.pl,
       akpm@linux-foundation.org, linux-usb@vger.kernel.org,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com
References: <201001202047.o0KKlMTr014003@mustang.cs.nmsu.edu> <8512e098224714ed7d54c62b46346796.squirrel@intranet.cs.nmsu.edu> <20100128072425.GA25633@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20100128072425.GA25633@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001280847.50445.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Am Donnerstag, 28. Januar 2010 08:24:26 schrieben Sie:
> > Again, like I said, I don't have a problem changing it. If it's wrong,
> > it's wrong no matter how many other drivers may take the same
> > approach.
> 
> I believe it is wrong.

So do I. You need not fail if copy_to_user() fails, but if you go
that route you need to evaluate the return value of copy_to_user()
and return:

not_written = copy_to_user(...);
return to_be_written - not_written ? to_be_written - not_written : -EFAULT;

	Regards
		Oliver
