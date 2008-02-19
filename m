Return-Path: <linux-kernel-owner+w=401wt.eu-S1761596AbYBSXjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761596AbYBSXjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 18:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbYBSXjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 18:39:03 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:52281 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbYBSXjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 18:39:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=GJNq812dc0P6k3p9n7xwYiGqbXg0vWLqO+ybswOHkgrs50DPEvajHE0HnHr/ciSHXXyzfASdIfKkx9tKmviYu4osQUD0aWm2yO/JPJL/gBJkwGhjEzx1NKLbJ8PVTCdmIaPN9p2Q5LP3VzHzoLynMWaBa9jBrTUR7HPK26iJZXc=
Message-ID: <2c0942db0802191538k79f93ca5p93a1883a449f3bb0@mail.gmail.com>
Date: Tue, 19 Feb 2008 15:38:58 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: usb/serial/io_ti.c: inconsequent NULL checking
Cc: "Adrian Bunk" <bunk@kernel.org>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080219232556.GB1963@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080219224915.GN31955@cs181133002.pp.htv.fi>
	 <20080219232556.GB1963@suse.de>
X-Google-Sender-Auth: a14e544e8c2840e1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 19, 2008 3:25 PM, Greg KH <gregkh@suse.de> wrote:
> On Wed, Feb 20, 2008 at 12:49:15AM +0200, Adrian Bunk wrote:
> > The Coverity checker spotted the following inconsequent NULL checking
> > introduced by commit d5f5bcd425b771c0b7ff5a650b2ce061ac8bbb87:
> >
> > <--  snip  -->
>
> It's not a real problem, that pointer can't go away.

I think he meant inconsistent not "inconsequent."

Either the test of port->tty here is unneeded:

 if (port->tty)
               port->tty->low_latency = low_latency;

...or the lack of test of port->tty here is a mistake:

	 edge_set_termios (port, port->tty->termios);
