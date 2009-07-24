Return-Path: <linux-kernel-owner+w=401wt.eu-S1753729AbZGXSCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbZGXSCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 14:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbZGXSCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 14:02:30 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2826 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbZGXSCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 14:02:30 -0400
Subject: Re: [PATCH] Removed useless retval variables in usb-serial.c
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>
Cc: Trevor Pace <tr212206@dal.ca>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090724173422.GA10989@suse.de>
References: <20090724124803.ltfbg57ooyoko0gs@my5.dal.ca>
	 <20090724173422.GA10989@suse.de>
Content-Type: text/plain
Date: Fri, 24 Jul 2009 11:02:22 -0700
Message-Id: <1248458542.3498.52.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-24 at 10:34 -0700, Greg KH wrote:
> On Fri, Jul 24, 2009 at 12:48:03PM -0300, Trevor Pace wrote:
> > Removed useless return value variables.
> They seem useful to me, especially as it causes the code to fall out of
> the function at the bottom, and not in the middle, which makes
> maintaining the code easier to do over time, right?

If paint for the bike shed is still required,
my preferences are:

If unwinding is required, gotos are useful
and the last return should be the error case.

If no unwinding is required, gotos tend to be
distracting and the last return should be the
no error case.

Trevor's new code does:

	if (port->serial->type->ioctl)
		return port->serial->type->ioctl(tty, file, cmd, arg);
	return -ENOIOCTLCMD;

where I would have preferred:

	if (!port->serial->type->ioctl)
		return -ENOIOCTLCMD;

	return port->serial->type->ioctl(tty, file, cmd, arg);


